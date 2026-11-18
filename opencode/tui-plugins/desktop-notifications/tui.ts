import { Plugin } from "@opencode/plugin/tui"
import { spawn } from "node:child_process"

function sendDesktopNotification(title: string, message: string) {
  try {
    const child = spawn("notify-send", ["-a", "OpenCode", title, message], {
      detached: true,
      stdio: "ignore",
    })
    child.unref()
  } catch (error) {
    console.debug("OpenCode desktop notification failed", error)
  }
}

export default Plugin.define({
  id: "jdyer.desktop-notifications",
  setup(context) {
    let focused = true
    const onFocus = () => {
      focused = true
    }
    const onBlur = () => {
      focused = false
    }
    context.renderer.on("focus", onFocus)
    context.renderer.on("blur", onBlur)

    const notify = (title: string, message: string) => {
      if (focused) return
      sendDesktopNotification(title, message)
    }

    const seenForms = new Set<string>()
    const seenPermissions = new Set<string>()
    const finished = new Set<string>()

    const runningSubagent = (sessionID: string) =>
      context.data.session.family(sessionID).some(
        (id) =>
          id !== sessionID &&
          context.data.session.get(id)?.parentID === sessionID &&
          context.data.session.status(id) === "running",
      )

    const finish = (sessionID: string, message: string) => {
      const session = context.data.session.get(sessionID)
      if (!session || session.parentID) return
      if (runningSubagent(sessionID)) return
      if (finished.has(sessionID)) return
      finished.add(sessionID)
      notify(session.title ?? "OpenCode", message)
    }

    const disposers = [
      context.data.on("form.created", (event) => {
        const id = event.data.form.id
        if (seenForms.has(id)) return
        seenForms.add(id)
        const session = context.data.session.get(event.data.form.sessionID)
        notify(
          event.data.form.title ?? session?.title ?? "OpenCode",
          "Input needs response",
        )
      }),
      context.data.on("form.replied", (event) => {
        seenForms.delete(event.data.id)
      }),
      context.data.on("form.cancelled", (event) => {
        seenForms.delete(event.data.id)
      }),
      context.data.on("permission.asked", (event) => {
        const id = event.data.id
        if (seenPermissions.has(id)) return
        seenPermissions.add(id)
        const session = context.data.session.get(event.data.sessionID)
        notify(session?.title ?? "OpenCode", "Permission needs input")
      }),
      context.data.on("permission.replied", (event) => {
        seenPermissions.delete(event.data.requestID)
      }),
      context.data.on("session.execution.started", (event) => {
        finished.delete(event.data.sessionID)
      }),
      context.data.on("session.execution.succeeded", (event) => {
        finish(event.data.sessionID, "Session done")
      }),
      context.data.on("session.execution.interrupted", (event) => {
        finish(event.data.sessionID, "Session interrupted")
      }),
      context.data.on("session.execution.failed", (event) => {
        const sessionID = event.data.sessionID
        const error = event.data.error
        if (
          error?.type === "provider.free-limit" ||
          error?.type === "provider.go-limit"
        ) {
          return
        }
        finish(sessionID, error?.message ?? "Session failed")
      }),
    ]

    const layer = context.keymap.layer(() => ({
      mode: "global",
      priority: 10,
      commands: [
        {
          id: "jdyer.desktop-notifications.test",
          title: "Test desktop notification",
          group: "Notifications",
          palette: true,
          slash: { name: "notify-test" },
          run: () => {
            context.ui.toast.show({
              message: "Switch to another desktop; test notification in 5 seconds…",
            })
            setTimeout(
              () => notify("OpenCode", "Desktop notification test"),
              5000,
            )
          },
        },
      ],
    }))

    return () => {
      context.renderer.off("focus", onFocus)
      context.renderer.off("blur", onBlur)
      for (const dispose of disposers) dispose()
      if (typeof layer === "function") layer()
    }
  },
})
