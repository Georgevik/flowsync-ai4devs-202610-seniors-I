---
name: priority-ticket
description: Fetch the highest-priority Jira ticket in "To Do" assigned to the current user, summarize its acceptance criteria, propose an implementation in plan mode, and move the ticket to "In Progress" once the plan is approved. Use when the user types /priority-ticket or asks "what should I work on next?".
---

# /priority-ticket

Pick up the next ticket from Jira and turn it into an approved implementation plan. Uses the Atlassian MCP server (`mcp__atlassian__*`, configured in `.mcp.json`). Load the tools you need with a single ToolSearch call before using them:

`select:mcp__atlassian__getAccessibleAtlassianResources,mcp__atlassian__searchJiraIssuesUsingJql,mcp__atlassian__getJiraIssue,mcp__atlassian__getTransitionsForJiraIssue,mcp__atlassian__transitionJiraIssue,EnterPlanMode,ExitPlanMode`

## 1. Find the ticket

1. Call `getAccessibleAtlassianResources` to get the `cloudId`. If there is more than one site, ask the user which one.
2. Search with `searchJiraIssuesUsingJql`:

   ```
   assignee = currentUser() AND statusCategory = "To Do" ORDER BY priority DESC, created ASC
   ```

   Take the first result (highest priority; oldest wins ties). If `$ARGUMENTS` contains a project key (e.g. `FS`), add `AND project = <KEY>` to the JQL.
3. If nothing comes back, tell the user they have no To Do tickets assigned and stop.
4. Fetch the full issue with `getJiraIssue` (description, priority, status, labels, linked issues, subtasks).

## 2. Summarize

Show the user, briefly:

- Key, title, priority, link to the ticket.
- **Acceptance criteria** as a checklist. Take them from the "Acceptance criteria" section or field if present; otherwise derive them from the description and say they were inferred.
- Anything ambiguous or missing in the ticket (open questions).

## 3. Plan

1. Call `EnterPlanMode`.
2. Explore the codebase to understand what the ticket touches. Follow `CLAUDE.md`: in this repo the backend is read-only reference (check `backend/app/validators/` and `start/routes.ts` for the exact API contract) and the work happens in `frontend/`.
3. Present the plan with `ExitPlanMode`. The plan must include:
   - Ticket key and title.
   - Acceptance criteria checklist, each one mapped to the step(s) that satisfy it.
   - Files to create/modify, with what changes in each.
   - New dependencies, if any, and why.
   - How to verify (commands to run, manual checks in the browser).
   - Open questions / assumptions.

If the user rejects the plan, revise it with their feedback and present it again. Do **not** transition the ticket while the plan is not approved.

## 4. Move to In Progress

Only after the plan is approved:

1. Call `getTransitionsForJiraIssue` and pick the transition whose target status is "In Progress" (match case-insensitively; fall back to a status in the "In Progress" category). Never hardcode transition IDs.
2. Call `transitionJiraIssue` with that transition ID.
3. Confirm to the user: `<KEY> moved to In Progress`. If no matching transition exists or the call fails, say so plainly and list the available transitions instead of guessing.

Then start implementing the approved plan.
