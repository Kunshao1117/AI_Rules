---
name: maps-assist
description: >
  Google Maps Platform development methods. Use when: explicit Google Maps Platform implementation, Places / Routes / Geocoding / Maps SDK or API architecture, Maps-specific debugging, or a specific Maps provider question.
  DO NOT use when: ordinary place lookup, general geography, location questions, generic UI, non-Google mapping, or an arbitrary map keyword without Google Maps development intent.
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# Google Maps Platform Development Methods

Disposition: KEEP_BUT_REWRITE. Maps Optional Pack.
Invocation classification: restricted; provider-specific: yes (Google Maps Platform).
Code Assist is an optional documentation provider, not the identity of this method.
No automatic sibling loading or pack activation. These classifications describe
method applicability, not invented native invocation enforcement metadata.

## Select the product and implementation boundary

1. Identify the user operation, required output, Google product, target platform,
   existing SDK/API version, framework integration and data origin. Separate Web,
   Android, iOS and server/Web Service needs; an SDK sample is not interchangeable
   with a server API or another platform's authentication and lifecycle.
2. Map the requested outcome to a narrow product candidate: Maps for display,
   Places for place search/details/autocomplete, Geocoding for address-coordinate
   conversion, Address Validation for address quality, Routes for routes/matrices.
   Navigation and fleet optimization are distinct needs, not implied by a route.
   Choose interactive versus static display and client SDK versus service calls
   using required interaction, security and the existing project boundary.
3. Inspect current official evidence for the selected API, SDK version/channel,
   fields, product availability and deprecations. Compare project dependencies,
   request/response shape and migration guidance; do not silently substitute
   latest or force an upstream Skill's library choice into an existing project.
   Record source/version and coverage limits. A docs result is not runtime proof.

## Apply Maps-specific methods

- **Location identity:** distinguish a place ID, address and latitude/longitude;
  check coordinate order, bounds, locale/region and ambiguity before using results.
  Reverse geocoding does not establish a precise entrance or validated address.
  Preserve the selected place identity through autocomplete and details requests.
- **Map UI:** inspect container size, loader lifecycle and library/version needs;
  avoid duplicate initialization and clean up listeners when views unmount.
  Preserve meaningful viewport/selection state, accessible place alternatives,
  keyboard/focus behavior and attribution visibility. Bound marker volume and
  choose clustering when useful; map IDs and advanced-marker requirements depend
  on the selected current SDK. Map rendering does not prove Places or Routes work.
- **Requests and cost:** identify actual billable events, expected volume, quota,
  returned fields and retry behavior. Request only needed Places fields; match
  autocomplete session-token lifecycle to the selected API's current billing
  rules. Debounce repeated user input and avoid duplicate requests where suitable.
  Do not treat a free tier, demo quota or a budget alert as unlimited use or a
  spending hard cap. Read current pricing/quota evidence; no automatic billing,
  quota changes or Cloud project creation follows a design recommendation.
- **Credential architecture:** distinguish prototype/demo keys, production API
  keys, server secrets and provider access credentials. Browser SDK keys can be
  client-visible; concealment in a bundle is not protection. Plan application
  and API restrictions for the actual platform, with separate keys where one
  restriction type cannot cover different platforms. Secret service credentials
  stay server-side. Reuse the project's approved configuration abstraction;
  never hardcode a key, ask for keys pasted into model context, acquire a key,
  login or inspect credential stores as a missing-key fallback. Restriction
  changes can break production clients; this method does not perform them.
- **Content provenance:** distinguish own geodata, Google Maps Content and other
  providers' content. Preserve required attribution in the actual display/export.
  Check product/region-specific current terms before caching, reuse or LLM use;
  an allowed place-ID storage exception does not permit caching all place data.
  Documentation grounding and processing live Maps Content are different uses.

## Evidence provider and existing owners

Read relevant facts in `Shared/policies/references/maps-guide.md` when selecting
Code Assist or checking version-sensitive product constraints. If Code Assist is
unavailable, blocked or present_unverified, use official Google Maps docs, official
GitHub, project-local docs or another authorized official-doc route; Maps source
work remains possible. State a specific evidence gap if no route can answer it.
Provider readiness is neither permission nor a completion decision. No implicit
install, upgrade, MCP configuration, credential creation or provider-state
persistence. No Memory / Project Context writes are part of this method.
The reference points to existing Execution, Authorization, Capability, Agent,
Model, Verification, Review, Completion and credential owners; none is redefined.
