import { describe, expect, test } from "bun:test"
import plugin, { kagiProvider } from "./kagi-websearch"

describe("kagi websearch plugin", () => {
  test("registers Kagi as a websearch provider", async () => {
    const added: { id: string; name: string }[] = []
    const ctx = { websearch: { transform: async (callback: (editor: any) => void) => callback({ add: (p: any) => added.push(p) }) } }
    await plugin.setup(ctx as any)
    expect(plugin.id).toBe("kagi.websearch")
    expect(added.map(({ id, name }) => ({ id, name }))).toEqual([{ id: "kagi", name: "Kagi" }])
  })

  test("posts the query to Kagi's v1 search API with bearer auth", async () => {
    const { fetch, requests } = fakeFetch(200, { data: { search: [] } })
    const signal = new AbortController().signal
    await kagiProvider(fetch, "secret").execute({ query: "opencode plugins" }, { signal })
    expect(requests).toHaveLength(1)
    const [url, init] = requests[0]
    expect(url).toBe("https://kagi.com/api/v1/search")
    expect(init.method).toBe("POST")
    expect(init.headers).toMatchObject({ Authorization: "Bearer secret", "Content-Type": "application/json" })
    expect(JSON.parse(init.body)).toEqual({ query: "opencode plugins", limit: 8 })
    expect(init.signal).toBe(signal)
  })

  test("maps search results to opencode's result schema", async () => {
    const { fetch } = fakeFetch(200, {
      data: {
        search: [{ url: "https://a.example", title: "A", snippet: "About A", time: "2025-01-02T00:00:00Z" }],
        related_search: [{ url: "https://kagi.com/search?q=b", title: "B" }],
      },
    })
    const results = await search(fetch)
    expect(results).toEqual([{ url: "https://a.example", title: "A", content: "About A", time: { published: Date.UTC(2025, 0, 2) } }])
  })

  test("strips highlighting and decodes HTML entities", async () => {
    const { fetch } = fakeFetch(200, {
      data: { search: [{ url: "https://a.example", title: "Encoder &amp; Decoder", snippet: "<strong>HTML</strong> don&#39;t use &amp;lt;div&amp;gt; or &lt;b&gt;" }] },
    })
    const [result] = await search(fetch)
    expect(result.title).toBe("Encoder & Decoder")
    expect(result.content).toBe("HTML don't use &lt;div&gt; or <b>")
  })

  test("omits missing snippets and publication times", async () => {
    const { fetch } = fakeFetch(200, { data: { search: [{ url: "https://a.example", title: "A", time: null }] } })
    expect(await search(fetch)).toEqual([{ url: "https://a.example", title: "A", time: {} }])
  })

  test("returns no results when Kagi finds nothing", async () => {
    const { fetch } = fakeFetch(200, { data: {} })
    expect(await search(fetch)).toEqual([])
  })

  test("fails on HTTP errors with Kagi's message", async () => {
    const { fetch } = fakeFetch(401, { data: null, error: [{ code: 2, msg: "Unauthorized" }] })
    await expect(search(fetch)).rejects.toThrow("Kagi search failed (HTTP 401): Unauthorized")
  })

  test("fails without an API key", async () => {
    const { fetch, requests } = fakeFetch(200, { data: { search: [] } })
    await expect(kagiProvider(fetch, undefined).execute({ query: "q" }, { signal: new AbortController().signal })).rejects.toThrow("KAGI_API_KEY is not set")
    expect(requests).toHaveLength(0)
  })
})

function search(fetch: typeof globalThis.fetch) {
  return kagiProvider(fetch, "secret").execute({ query: "q" }, { signal: new AbortController().signal })
}

function fakeFetch(status: number, body: unknown) {
  const requests: [string, any][] = []
  const fetch = (async (url: string, init: any) => {
    requests.push([url, init])
    return new Response(JSON.stringify(body), { status })
  }) as unknown as typeof globalThis.fetch
  return { fetch, requests }
}
