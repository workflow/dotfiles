import { describe, expect, test } from "bun:test"
import plugin, { tabTitleSync } from "./herdr-tab-title"

describe("herdr tab title plugin", () => {
  test("is a V2 TUI plugin definition", () => {
    expect(plugin.id).toBe("herdr.tab-title")
    expect(typeof plugin.setup).toBe("function")
  })

  test("renames the tab to the routed session's title", () => {
    const { tui, sync, renames } = load()
    tui.show({ id: "ses_1", title: "Fix the boot loader" })
    sync()
    expect(renames).toEqual(["Fix the boot loader"])
  })

  test("names the tab after the root while a child session is routed", () => {
    const { tui, sync, renames } = load()
    tui.add({ id: "ses_root", title: "Fix the boot loader" })
    tui.show({ id: "ses_child", title: "Explore repo", parentID: "ses_root" })
    sync()
    expect(renames).toEqual(["Fix the boot loader"])
  })

  test("ignores untitled sessions and placeholder titles", () => {
    const { tui, sync, renames } = load()
    tui.show({ id: "ses_1" })
    sync()
    tui.show({ id: "ses_2", title: "New session - 2026-09-14T18:54:57.880Z" })
    sync()
    tui.show({ id: "ses_3", title: "Child session - 2026-09-14T18:54:57.880Z" })
    sync()
    expect(renames).toEqual([])
  })

  test("ignores routes other than sessions", () => {
    const { tui, sync, renames } = load()
    tui.home()
    sync()
    expect(renames).toEqual([])
  })

  test("renames once per distinct title", () => {
    const { tui, sync, renames } = load()
    tui.show({ id: "ses_1", title: "Same title" })
    sync()
    sync()
    tui.add({ id: "ses_1", title: "Renamed title" })
    sync()
    expect(renames).toEqual(["Same title", "Renamed title"])
  })
})

type Session = { id: string; title?: string; parentID?: string }

function load() {
  const tui = fakeTui()
  const renames: string[] = []
  const sync = tabTitleSync(tui.api as any, (title) => renames.push(title))
  return { tui, sync, renames }
}

function fakeTui() {
  const sessions = new Map<string, Session>()
  let route: { type: "home" } | { type: "session"; sessionID: string } = { type: "home" }
  const root = (id: string): string => {
    const parentID = sessions.get(id)?.parentID
    return parentID ? root(parentID) : id
  }
  return {
    api: {
      ui: { router: { current: () => route } },
      data: { session: { get: (id: string) => sessions.get(id), root } },
    },
    add: (session: Session) => void sessions.set(session.id, session),
    show(session: Session) {
      this.add(session)
      route = { type: "session", sessionID: session.id }
    },
    home: () => void (route = { type: "home" }),
  }
}
