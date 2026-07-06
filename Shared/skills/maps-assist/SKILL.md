---
name: maps-assist
description: >
  地圖功能文件查詢與策略輔助（MCP: google-maps）：Maps API、地點、路線、地理編碼開發；
  Google Maps Platform code assist.
  Use when: 需要開發 Google 地圖、places、routes、geocoding、markers、
  或 Maps API 功能並查詢官方文件。
  DO NOT use when: 任務不是地圖功能開發，或不需要 Google Maps Platform 文件證據。
metadata:
  author: antigravity
  version: "5.1"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [google-maps]
  tool_scope: ["mcp:google-maps"]
---

# Maps Assist

## Trigger Conditions

- 實作 Google Maps features（markers, routes, places, geocoding）
- 排除 Maps API errors 或 migration 問題

## Procedure

### Step 1: Load Instructions, Mandatory First

**MUST call `retrieve-instructions` BEFORE any other gmp tool.**

This returns foundational context for effective search queries.

### Step 2: Search Documentation

Call `retrieve-google-maps-platform-docs` with:

- Specific, focused queries (e.g., "Advanced Markers styling" NOT "maps")
- Include `search_context` array for product/feature names

### Step 3: Apply Results

- Use retrieved code samples as reference, adapt to project tech stack
- Verify API version matches project requirements

## Constraints

- **Instruction-First Rule**: Calling docs without instructions = poor query quality = wasted context
- **Read-Only**: This MCP can only retrieve information, NOT create projects or manage API keys
- **Context Budget**: Retrieved docs consume context window. Use focused queries to minimize waste

## Done When

- Relevant documentation retrieved for the specific Maps feature
- Code implementation follows retrieved best practices
