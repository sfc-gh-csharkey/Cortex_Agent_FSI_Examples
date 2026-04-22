# Cortex Agent FSI Examples
<img width="85" alt="map-user" src="https://img.shields.io/badge/views-010-green"> <img width="125" alt="map-user" src="https://img.shields.io/badge/unique visits-001-green">

Cortex Agent is a service that allows you to create AI-powered conversational agents that can answer questions about your data.

Key Concepts
  * Purpose: Agents act as intelligent assistants that understand your business domain and can query your data using natural language
  * Instructions: Contain curated guidance about which data sources to use for which types of questions
  * Tools: Define capabilities the agent can use (e.g., querying semantic views, executing SQL)
  * Linked Data Sources: Connect to semantic views, tables, or other data assets

How They Work
  1. You define an agent with instructions about your domain
  2. The agent maps user questions to appropriate tools and data sources
  3. Users can ask natural language questions like "What was our revenue last quarter?"
  4. The agent translates this to the correct queries against your Snowflake data

## How to deploy / use the code sample(s)

This repository can deploy an investment research assistant agent. You can ask the agent questions and it can search news and query Snowflake tables related to research intelligence (research note, securities) and trade analytics (securities, trades, market_data)

This repository assumes you have deployed
1. Cortex Search Service [News_Search](https://github.com/sfc-gh-csharkey/Cortex_Search_FSI_Examples/tree/main/NEWS_SEARCH)
2. Cortex Analyst [Research_Intelligence](https://github.com/sfc-gh-csharkey/Cortex_Analyst_FSI_Examples/tree/main/Research_Intelligence) and [Trading_Analytics](https://github.com/sfc-gh-csharkey/Cortex_Analyst_FSI_Examples/tree/main/Trading_Analytics)

These search and analyst services are required because they will be tools the research assistant agent can call.

Once the dependencies are deployed run the SQL in the [investment_research_assistant.sql](https://github.com/sfc-gh-csharkey/Cortex_Agent_FSI_Examples/blob/main/investment_research_assistant.sql) file to deploy the agent.

The agent can be invoked in different ways, an easy way to invoke it is via. the GUI in Snowsight.

To access the GUI select AI/ML services from the side bar, then agents, then select the INVESTMENT_RESEARCH_ASSISTANT agent.

<img width="900" alt="quick_setup" src="https://github.com/sfc-gh-csharkey/Cortex_Agent_FSI_Examples/blob/main/READ_ME/GUI_1.png">

Enter your question to the agent in via. the prompt area in the bottom right of the screen

<img width="900" alt="quick_setup" src="https://github.com/sfc-gh-csharkey/Cortex_Agent_FSI_Examples/blob/main/READ_ME/GUI_2.png">

After you ask the agent a question, if you want to better understand what tools the agent invoked, token count usage you can select the monitoring tab on the top left of the screen, then select the most recent trace.

You will see a screen similar to the one pictured below

<img width="900" alt="quick_setup" src="https://github.com/sfc-gh-csharkey/Cortex_Agent_FSI_Examples/blob/main/READ_ME/Trace.png">
