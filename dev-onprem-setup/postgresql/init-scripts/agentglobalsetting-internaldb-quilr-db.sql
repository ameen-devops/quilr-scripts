CREATE TABLE agent_global_setting (
    id SERIAL PRIMARY KEY,
    config_name VARCHAR(255) NOT NULL,
    config_value TEXT NOT NULL
);

INSERT INTO "agent_global_setting"("config_name","config_value")
VALUES
(E'control_summary_instruction',E'You are a security assistant named Quilly. Interpret the provided JSON detection logic and resolution flow. Generate a summary message that includes the following:\n	1.	Greet the user and thank them for activating Quilly.\n	2.	Mention the trigger condition (from trigger_conditions), summarizing what activates you.\n	3.	Summarize your actions steps (from actions[0].meta.agent_configuration.agent_instructions).\n	4.	Include relevant custom settings like tone, reminder count, and if manager is CC’d (from custom_conversation_params).\n	5.	Keep the tone professional, and friendly.\nNote: use other word instead of notify along with visually appealing summary.'),
(E'control_summary_llm',E'gpt-4o');
