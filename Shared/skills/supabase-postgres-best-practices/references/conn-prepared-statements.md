# Prepared statements and pool compatibility

Identify the actual pool implementation, mode, driver and prepared-statement behavior.
Current Supabase/Supavisor facts belong to `Shared/policies/references/supabase-guide.md`
and its connection documentation. For a pool mode without prepared-statement support,
disable them only through the actual driver's documented option or select an already
authorized compatible connection route. Do not invent a universal Node/ORM setting.

Named PREPARE/EXECUTE across different transactions may land on different server sessions.
DEALLOCATE after use does not fix that session-affinity problem. Session/direct mode may
fit workloads that need session state. Do not infer mode from a port number alone or change
provider/configuration automatically. Validate the deployed driver/mode combination with
the project's admitted evidence method.
