import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Collapser: a chevron bar widget that smoothly collapses every other
// right-section widget placed before it in layout order, and expands them
// again on a second click. State is shared across every monitor's bar
// instance via broadcast(), and persisted across plugin hot-reloads.
BarWidget {
  id: root
  moduleName: "local.collapser"

  readonly property int animDuration: 220

  PersistentProperties {
    id: persisted
    reloadableId: "local-collapser"
    // Collapsed by default: the widgets only show after an explicit click.
    property bool collapsed: true
  }

  // Animations currently in flight, keyed by nothing in particular — just
  // kept alive here so they are not garbage collected mid-run, and stopped
  // before a new batch starts.
  property var runningAnimations: []

  function entryId(entry) {
    if (!entry) return ""
    if (typeof entry === "string") return entry
    return String(entry.id || "")
  }

  // Ids (as they appear in bar.layoutConfig.right) that sit before us.
  function idsBeforeSelf() {
    if (!root.bar) return []
    var right = (root.bar.layoutConfig && root.bar.layoutConfig.right) || []
    var ids = []
    for (var i = 0; i < right.length; i++) {
      var id = root.entryId(right[i])
      if (id === root.moduleName) break
      ids.push(id)
    }
    return ids
  }

  // Live slots (across every registered slot on THIS bar instance) that we
  // are responsible for collapsing. Re-scanned every time — slots get
  // destroyed and recreated on hot reload, so nothing here is cached.
  function targetSlots() {
    if (!root.bar) return []
    var ids = root.idsBeforeSelf()
    var slots = root.bar.moduleSlots || []
    var result = []
    for (var i = 0; i < slots.length; i++) {
      var slot = slots[i]
      if (!slot) continue
      if (slot.region !== "right") continue
      if (slot.moduleName === root.moduleName) continue
      if (ids.indexOf(slot.moduleName) === -1) continue
      result.push(slot)
    }
    return result
  }

  function stopRunningAnimations() {
    for (var i = 0; i < root.runningAnimations.length; i++) {
      var anim = root.runningAnimations[i]
      if (anim && anim.stop) anim.stop()
    }
    root.runningAnimations = []
  }

  function animateSlot(slot, collapsing) {
    if (!slot) return
    var vertical = root.vertical
    var sizeProp = vertical ? "height" : "width"

    // Freeze the geometry with an explicit value so the animation has a
    // starting point to animate away from (this breaks the
    // `width: implicitWidth` binding, which is expected while collapsed).
    slot[sizeProp] = slot[sizeProp]
    slot.clip = true

    var target = collapsing ? 0 : (vertical ? slot.implicitHeight : slot.implicitWidth)

    var sizeAnim = Qt.createQmlObject(
      'import QtQuick; NumberAnimation { duration: ' + root.animDuration
      + '; easing.type: Easing.InOutCubic }', root, "collapserSizeAnim")
    sizeAnim.target = slot
    sizeAnim.property = sizeProp
    sizeAnim.to = target

    var opacityAnim = Qt.createQmlObject(
      'import QtQuick; NumberAnimation { duration: ' + root.animDuration
      + '; easing.type: Easing.InOutCubic }', root, "collapserOpacityAnim")
    opacityAnim.target = slot
    opacityAnim.property = "opacity"
    opacityAnim.to = collapsing ? 0 : 1

    root.runningAnimations.push(sizeAnim)
    root.runningAnimations.push(opacityAnim)

    if (!collapsing) {
      opacityAnim.finished.connect(function() { root.restoreSlot(slot) })
    }

    sizeAnim.start()
    opacityAnim.start()
  }

  // Restores the live size binding so future implicit size changes (e.g. a
  // widget's own content resizing) keep tracking automatically. Must stay a
  // function taking the slot as a parameter: a binding closure created inside
  // a `for` loop over a `var` would capture the loop variable itself, leaving
  // every slot bound to the last slot's implicit size.
  function restoreSlot(slot) {
    slot.clip = false
    if (root.vertical) {
      slot.height = Qt.binding(function() { return slot.implicitHeight })
    } else {
      slot.width = Qt.binding(function() { return slot.implicitWidth })
    }
    slot.opacity = 1
  }

  function collapseSlot(slot) {
    slot.clip = true
    if (root.vertical) slot.height = 0
    else slot.width = 0
    slot.opacity = 0
  }

  function applyState(animated) {
    var slots = root.targetSlots()
    root.stopRunningAnimations()
    for (var i = 0; i < slots.length; i++) {
      if (animated) root.animateSlot(slots[i], persisted.collapsed)
      else if (persisted.collapsed) root.collapseSlot(slots[i])
      else root.restoreSlot(slots[i])
    }
  }

  // Sets the explicit target value on every live instance of this widget
  // (one per monitor bar). Broadcasting an explicit boolean, rather than
  // having each instance flip its own independent PersistentProperties
  // value, keeps every monitor consistent even if the IPC call happens to
  // reach more than one instance's handler for the same invocation.
  function setAll(target) {
    var items = root.bar && typeof root.bar.moduleWidgets === "function"
      ? root.bar.moduleWidgets(root.moduleName) : [root]
    for (var i = 0; i < items.length; i++) {
      if (items[i] && typeof items[i].applySharedState === "function") items[i].applySharedState(target)
    }
  }

  // Called on every live instance (across every monitor) via setAll().
  function applySharedState(target) {
    persisted.collapsed = target
    root.applyState(true)
  }

  function toggle() {
    root.setAll(!persisted.collapsed)
  }

  function collapse() {
    root.setAll(true)
  }

  function expand() {
    root.setAll(false)
  }

  Component.onCompleted: {
    // Re-apply the current shared state without animation on (re)creation,
    // so a hot reload or a newly connected monitor lands in the right
    // visual state immediately.
    Qt.callLater(function() { root.applyState(false) })
  }

  IpcHandler {
    target: "collapser"

    function toggle(): string { root.toggle(); return "ok" }
    function collapse(): string { root.collapse(); return "ok" }
    function expand(): string { root.expand(); return "ok" }
  }

  implicitWidth: vertical ? barSize : icon.implicitWidth
  implicitHeight: vertical ? icon.implicitHeight : barSize

  // Chevron points left ("<", collapse toward me) when expanded, and rotates
  // 180deg to point right ("<" flipped, expand) once collapsed.
  Behavior on chevronRotation {
    NumberAnimation { duration: root.animDuration; easing.type: Easing.InOutCubic }
  }
  property real chevronRotation: persisted.collapsed ? 180 : 0

  BarIconButton {
    id: icon
    bar: root.bar
    text: ""
    tooltipText: persisted.collapsed ? "Expand" : "Collapse"
    textRotation: root.chevronRotation
    onPressed: function() { root.toggle() }
  }
}

