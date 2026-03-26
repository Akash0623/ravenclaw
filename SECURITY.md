# Security Policy — Ravenclaw

Ravenclaw is a personal fork of [OpenClaw](https://github.com/openclaw/openclaw). This security policy covers Ravenclaw-specific code and configuration only.

For vulnerabilities in upstream OpenClaw, please report directly to the [openclaw/openclaw](https://github.com/openclaw/openclaw) repository.

---

## Reporting a Vulnerability

If you find a security issue in Ravenclaw-specific code:

1. **Open a GitHub issue** at [github.com/Akash0623/ravenclaw/issues](https://github.com/Akash0623/ravenclaw/issues) with the label `security`
2. Or **email** akash@visioncircuitlabs.com with a brief description

Include:
- What you found and where (file, function, or config)
- Steps to reproduce
- The potential impact
- Your suggested fix if you have one

There is no bug bounty program. Reports are addressed on a best-effort basis.

---

## Scope

In scope for this repository:

- Ravenclaw-specific configuration, patches, and extensions
- Custom skills or tools added in this fork
- Docker and deployment configuration in this repo
- Anything in this codebase that diverges from upstream OpenClaw

Out of scope:

- Issues that exist identically in upstream OpenClaw (report those upstream)
- Prompt injection without a boundary bypass (this is a known limitation of all LLM systems)
- Issues requiring physical access to the host machine
- Denial-of-service against the local gateway on a single-user setup

---

## API Key Handling Best Practices

Ravenclaw uses several API keys (Anthropic, OpenRouter, Telegram, etc.). Follow these rules to keep them safe:

**Do:**
- Store all keys in `.env` — this file is gitignored by default
- Rotate keys immediately if you suspect they've been exposed
- Use `.env.example` (no real values) as the committed reference
- Restrict API key permissions to the minimum needed on each provider's dashboard

**Do not:**
- Commit `.env` to git — ever
- Hardcode keys in any config file, skill, or script
- Share your gateway publicly without setting `OPENCLAW_GATEWAY_PASSWORD`
- Log full API responses in production (they may contain sensitive content)

If you accidentally commit a key, assume it is compromised. Revoke it on the provider's dashboard immediately, then remove it from git history using `git filter-repo` or contact GitHub support for private repos.

---

## ClawHub Skill Security

ClawHub is the OpenClaw skill marketplace. Installing skills from ClawHub carries inherent risk:

- Skills run with the same OS privileges as the OpenClaw gateway process
- A malicious skill can read files, make network requests, and execute commands on your host
- There is no sandboxing between skills and the host by default

Ravenclaw-specific guidance:

- Only install skills from sources you trust
- Review skill code before enabling it, especially skills that use `tools.exec` or make outbound network calls
- Use `plugins.allow` in your config to pin an explicit allowlist of trusted skill IDs
- If you need stricter isolation, enable sandbox mode (`agents.defaults.sandbox.mode: non-main`) in your OpenClaw config

The upstream ClawHub team maintains their own review process, but Ravenclaw makes no guarantees about third-party skills. Treat skill installation like installing software on your computer — only do it if you trust the source.

---

## Deployment Security Notes

- Keep the gateway loopback-only (`OPENCLAW_GATEWAY_BIND=localhost`) unless you have a specific reason to expose it
- If you expose the gateway to a network, always set `OPENCLAW_GATEWAY_PASSWORD` to a strong password
- Never expose the gateway directly to the public internet without a firewall or reverse proxy
- For remote access, use an SSH tunnel or Tailscale rather than binding to `0.0.0.0`

---

*This policy applies to the Ravenclaw fork. For OpenClaw's full trust model and security guidance, see [trust.openclaw.ai](https://trust.openclaw.ai).*
