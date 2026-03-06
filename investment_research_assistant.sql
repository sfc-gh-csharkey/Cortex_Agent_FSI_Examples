-- =============================================================================
-- Deploy Investment Research Assistant Cortex Agent
-- =============================================================================
-- Prerequisites:
--   - FSI_DEMO_DB.CAPITAL_MARKETS.NEWS_ARTICLES_SEARCH_INDEX (Cortex Search Service)
--   - FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_INTELLIGENCE (Semantic View)
--   - FSI_DEMO_DB.CAPITAL_MARKETS.TRADING_ANALYTICS (Semantic View)
-- =============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE FSI_DEMO_DB;
USE SCHEMA CAPITAL_MARKETS;

CREATE OR REPLACE AGENT INVESTMENT_RESEARCH_ASSISTANT
  COMMENT = 'Investment Research Assistant combining news search, analyst research, and trading analytics'
  PROFILE = '{"display_name": "Investment Research Assistant", "color": "blue"}'
  FROM SPECIFICATION $$
models:
  orchestration: claude-3-5-sonnet

orchestration:
  budget:
    seconds: 900
    tokens: 400000

instructions:
  orchestration: |
    You are an Investment Research Assistant helping financial analysts and portfolio managers with their research needs. You have access to three powerful tools:

    1. **news_search**: Search for financial news articles about companies, sectors, or market events. Use this to find recent news, sentiment analysis, and market updates. Filter by ticker symbols or sectors when specific securities are mentioned.

    2. **research_intelligence**: Query analyst research notes including recommendations (BUY/SELL/HOLD), target prices, rating changes (upgrades/downgrades), and research reports by analyst or security.

    3. **trading_analytics**: Analyze trading activity including price data (open/high/low/close), volume, VWAP, trade executions, and market data for securities.

    When asked about a company or ticker, consider using multiple tools to provide comprehensive insights. Always cite your sources and be concise but thorough.

  response: |
    Provide clear, actionable insights for investment decisions. Structure your response with relevant data points, cite sources (news articles, research notes, market data dates), and highlight key findings. Use bullet points for readability when presenting multiple data points.

  sample_questions:
    - question: "What are the latest analyst recommendations for tech stocks?"
      answer: "I'll query the research intelligence data to find recent analyst ratings and target prices for technology sector stocks."
    - question: "Show me recent news about Apple"
      answer: "I'll search the news database for recent articles mentioning AAPL or Apple Inc."
    - question: "What's the trading volume trend for MSFT?"
      answer: "I'll analyze the trading data to show volume patterns and metrics for Microsoft."

tools:
  - tool_spec:
      type: cortex_search
      name: news_search
      description: "Search for financial news articles, market updates, and company-specific news. Use this tool to find recent news about companies by ticker symbol, sector news, market sentiment, and breaking financial events. Returns headlines, summaries, sentiment scores, and source information."

  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: research_intelligence
      description: "Query analyst research notes, recommendations, and target prices. Use this tool to find analyst ratings (BUY/SELL/HOLD/OVERWEIGHT/NEUTRAL), target price changes, rating upgrades and downgrades, research report details by analyst or security, and historical recommendation trends."

  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: trading_analytics
      description: "Analyze trading activity and market data. Use this tool to query price data (open/high/low/close/adjusted close), trading volume, VWAP, bid-ask spreads, trade executions, commissions, and performance metrics for securities across different time periods."

tool_resources:
  news_search:
    name: FSI_DEMO_DB.CAPITAL_MARKETS.NEWS_ARTICLES_SEARCH_INDEX
    max_results: "10"

  research_intelligence:
    semantic_view: FSI_DEMO_DB.CAPITAL_MARKETS.RESEARCH_INTELLIGENCE

  trading_analytics:
    semantic_view: FSI_DEMO_DB.CAPITAL_MARKETS.TRADING_ANALYTICS
$$;

-- =============================================================================
-- Verify the agent was created
-- =============================================================================

SHOW AGENTS LIKE 'INVESTMENT_RESEARCH_ASSISTANT' IN SCHEMA FSI_DEMO_DB.CAPITAL_MARKETS;

DESCRIBE AGENT FSI_DEMO_DB.CAPITAL_MARKETS.INVESTMENT_RESEARCH_ASSISTANT;

-- =============================================================================
-- Test the agent
-- =============================================================================

SELECT SNOWFLAKE.CORTEX.AGENT(
    'FSI_DEMO_DB.CAPITAL_MARKETS.INVESTMENT_RESEARCH_ASSISTANT',
    'What can you do?'
);

-- Example queries:
-- SELECT SNOWFLAKE.CORTEX.AGENT('FSI_DEMO_DB.CAPITAL_MARKETS.INVESTMENT_RESEARCH_ASSISTANT', 'What are the latest analyst upgrades?');
-- SELECT SNOWFLAKE.CORTEX.AGENT('FSI_DEMO_DB.CAPITAL_MARKETS.INVESTMENT_RESEARCH_ASSISTANT', 'Search for recent news about the technology sector');
-- SELECT SNOWFLAKE.CORTEX.AGENT('FSI_DEMO_DB.CAPITAL_MARKETS.INVESTMENT_RESEARCH_ASSISTANT', 'Show me trading volume by sector');
