import { describe, expect, test } from "bun:test"
import type { Event } from "@opencode-ai/sdk"
import type { Hooks } from "@opencode-ai/plugin"
import { HerdrTabTitlePlugin } from "./herdr-tab-title"

describe("herdr tab title plugin", () => {
  test("renames the tab to a top-level session's title", async () => {
    const { hooks, calls } = await load()
    await emit(hooks, sessionUpdated({ title: "Fix the boot loader" }))
    expect(calls).toEqual([[SCRIPT, "Fix the boot loader"]])
  })

  test("ignores child (subagent) sessions", async () => {
    const { hooks, calls } = await load()
    await emit(hooks, sessionUpdated({ title: "Explore repo", parentID: "ses_parent" }))
    expect(calls).toEqual([])
  })

  test("ignores placeholder titles opencode assigns before naming", async () => {
    const { hooks, calls } = await load()
    await emit(hooks, sessionUpdated({ title: "New session - 2026-09-14T18:54:57.880Z" }))
    await emit(hooks, sessionUpdated({ title: "Child session - 2026-09-14T18:54:57.880Z" }))
    expect(calls).toEqual([])
  })

  test("ignores other events", async () => {
    const { hooks, calls } = await load()
    await emit(hooks, { type: "session.idle", properties: { sessionID: "ses_1" } } as Event)
    expect(calls).toEqual([])
  })

  test("renames once per distinct title", async () => {
    const { hooks, calls } = await load()
    await emit(hooks, sessionUpdated({ title: "Same title" }))
    await emit(hooks, sessionUpdated({ title: "Same title" }))
    await emit(hooks, sessionUpdated({ title: "Renamed title" }))
    expect(calls).toEqual([[SCRIPT, "Same title"], [SCRIPT, "Renamed title"]])
  })
})

const SCRIPT = "@herdrTabTitle@"

async function load(): Promise<{ hooks: Hooks; calls: string[][] }> {
  const calls: string[][] = []
  const hooks = await HerdrTabTitlePlugin({ $: fakeShell(calls) } as any)
  return { hooks, calls }
}

async function emit(hooks: Hooks, event: Event): Promise<void> {
  await hooks.event!({ event })
}

function sessionUpdated(session: { title: string; parentID?: string }): Event {
  return {
    type: "session.updated",
    properties: { info: { id: "ses_1", ...session } },
  } as unknown as Event
}

function fakeShell(calls: string[][]) {
  return (_strings: TemplateStringsArray, ...values: unknown[]) => {
    calls.push(values.map(String))
    const result: any = Promise.resolve({ exitCode: 0 })
    result.quiet = () => result
    result.nothrow = () => result
    return result
  }
}
