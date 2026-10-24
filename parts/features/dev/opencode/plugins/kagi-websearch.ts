// Kagi as opencode 2.x's websearch provider; the built-in ones (Exa,
// Firecrawl, Parallel, Tavily, ...) don't include it. Reads the same
// KAGI_API_KEY as the kagimcp MCP server.
const KAGI_SEARCH_URL = "https://kagi.com/api/v1/search"
// Matches the result count of opencode's built-in providers.
const MAX_RESULTS = 8

type WebSearchResult = { url: string; title?: string; content?: string; time: { published?: number } }
type KagiResult = { url: string; title: string; snippet?: string | null; time?: string | null }
type KagiResponse = { data?: { search?: KagiResult[] } | null; error?: { msg: string }[] | null }

export default {
  id: "kagi.websearch",
  async setup(ctx: any) {
    await ctx.websearch.transform((editor: any) => editor.add(kagiProvider(fetch, process.env.KAGI_API_KEY)))
  },
}

export function kagiProvider(fetchImpl: typeof fetch, apiKey: string | undefined) {
  return {
    id: "kagi",
    name: "Kagi",
    async execute({ query }: { query: string }, { signal }: { signal: AbortSignal }): Promise<WebSearchResult[]> {
      if (!apiKey) throw new Error("Kagi search failed: KAGI_API_KEY is not set")
      const response = await postSearch(fetchImpl, apiKey, query, signal)
      return (response.data?.search ?? []).map(toWebSearchResult)
    },
  }
}

async function postSearch(fetchImpl: typeof fetch, apiKey: string, query: string, signal: AbortSignal): Promise<KagiResponse> {
  const response = await fetchImpl(KAGI_SEARCH_URL, {
    method: "POST",
    headers: { Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json" },
    body: JSON.stringify({ query, limit: MAX_RESULTS }),
    signal,
  })
  if (!response.ok) throw new Error(`Kagi search failed (HTTP ${response.status}): ${await errorMessage(response)}`)
  return (await response.json()) as KagiResponse
}

async function errorMessage(response: Response) {
  const text = await response.text()
  try {
    return (JSON.parse(text) as KagiResponse).error?.map((e) => e.msg).join("; ") || text
  } catch {
    return text
  }
}

function toWebSearchResult(result: KagiResult): WebSearchResult {
  const published = result.time ? Date.parse(result.time) : NaN
  return {
    url: result.url,
    title: plainText(result.title),
    ...(result.snippet ? { content: plainText(result.snippet) } : {}),
    time: Number.isFinite(published) ? { published } : {},
  }
}

// Kagi returns HTML-escaped text with <strong> query highlighting. Tags go
// first so escaped markup like &lt;div&gt; survives as literal text.
function plainText(html: string) {
  return html.replace(/<[^>]*>/g, "").replace(/&(amp|lt|gt|quot|#39);/g, (_, entity: string) => HTML_ENTITIES[entity])
}

const HTML_ENTITIES: Record<string, string> = { amp: "&", lt: "<", gt: ">", quot: '"', "#39": "'" }
