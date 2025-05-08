import streamlit as st
import pandas as pd
import os
from mcp_client import MCPClient

# Page configuration
st.set_page_config(
    page_title="PostgreSQL Queries with MCP",
    page_icon="🔍",
    layout="wide"
)

# Title and description
st.title("📊 Natural Language PostgreSQL Queries")
st.markdown("""
This application allows you to query a PostgreSQL database using natural language.
Write your question in English and Claude will generate the appropriate SQL query and execute it to show the results.
""")

# Get credentials (ideally from environment variables or a secure configuration file)
def load_credentials():
    # Try to load from environment variables
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    pg_connection = os.environ.get("PG_CONNECTION")

    # If not in environment variables, look in session_state or default values
    if not api_key:
        api_key = st.session_state.get("api_key", "")
    if not pg_connection:
        pg_connection = st.session_state.get("pg_connection", "postgresql://mcp_user:123456@localhost:5432/mcp_db")

    return api_key, pg_connection

# Configuration in the sidebar
with st.sidebar:
    st.header("Configuration")

    # Load current credentials
    current_api_key, current_pg_connection = load_credentials()

    # Configuration fields
    api_key = st.text_input("Anthropic API Key:",
                           value=current_api_key,
                           type="password",
                           help="Your Anthropic API key")

    pg_connection = st.text_input("PostgreSQL Connection:",
                                 value=current_pg_connection,
                                 help="PostgreSQL connection string")

    model = st.selectbox("Claude Model:",
                        ["claude-3-haiku-20240307", "claude-3-sonnet-20240229", "claude-3-opus-20240229"],
                        help="Claude model to use")

    # Save configuration in session_state
    if st.button("Save Configuration"):
        st.session_state["api_key"] = api_key
        st.session_state["pg_connection"] = pg_connection
        st.session_state["model"] = model
        st.success("Configuration saved!")

    # Show information about the database structure
    st.subheader("Database Structure")
    st.markdown("""
    1. **departments** (id, name, location)
    2. **employees** (id, first_name, last_name, email, hire_date, salary, department_id)
       - department_id → departments(id)
    3. **projects** (id, name, start_date, end_date, budget, status)
    4. **assignments** (employee_id, project_id, assignment_date, role)
       - employee_id → employees(id)
       - project_id → projects(id)
    """)

# Query processing
def process_query(question):
    # Load credentials
    api_key, pg_connection = load_credentials()
    model = st.session_state.get("model", "claude-3-haiku-20240307")

    # Verify that we have an API key
    if not api_key:
        st.error("API Key not configured. Please configure it in the sidebar.")
        return None

    # Create MCP client
    client = MCPClient(api_key, pg_connection, model)

    # Callback to show progress
    status_placeholder = st.empty()
    def update_status(message):
        status_placeholder.info(message)

    # Execute query
    with st.spinner("Processing your query..."):
        result = client.query(question, callback=update_status)
        status_placeholder.empty()  # Clear status message when finished

    return result

# Main area
col1, col2 = st.columns([2, 1])

with col1:
    # Text input for the query
    user_query = st.text_area("Write your query in natural language:",
                              placeholder="Example: How many employees are in each department?",
                              height=100)

with col2:
    # Example queries
    st.subheader("Example Queries")
    examples = [
        "How many employees are in the Technology department?",
        "What is the average salary by department?",
        "Which projects are currently in progress?",
        "Who is the employee with the highest salary?",
        "In which projects does John Smith participate?"
    ]

    # Function to set an example as the current query
    def set_example(example):
        st.session_state.user_query = example

    # Show examples as buttons
    for example in examples:
        if st.button(f"▶ {example}", key=f"example_{example}"):
            set_example(example)
            st.rerun()

# Update the text area if an example was selected
if "user_query" in st.session_state:
    user_query = st.session_state.user_query

# Button to execute the query
if st.button("Execute Query", type="primary"):
    if not user_query:
        st.warning("Please write a query first.")
    else:
        # Execute the query
        result = process_query(user_query)

        # Show results in tabs
        if result:
            if result.get("success", False):
                tabs = st.tabs(["Results", "SQL Query", "Complete Response"])

                # Results tab
                with tabs[0]:
                    if result["column_names"]:
                        st.subheader("Query Results")

                        # Create a DataFrame to display the results
                        df = pd.DataFrame(result["results"], columns=result["column_names"])
                        st.dataframe(df, use_container_width=True)

                        # Options to download results
                        st.download_button(
                            label="Download as CSV",
                            data=df.to_csv(index=False).encode('utf-8'),
                            file_name='results.csv',
                            mime='text/csv',
                        )

                        st.info(f"Total results: {len(result['results'])}")
                    else:
                        st.warning("The query returned no results or there was an error.")

                # SQL query tab
                with tabs[1]:
                    st.subheader("Generated SQL Query")
                    st.code(result["sql_query"], language="sql")

                    # Option to copy the SQL query
                    st.text_area("SQL Query to copy:", value=result["sql_query"], height=100)

                # Complete response tab
                with tabs[2]:
                    st.subheader("Complete Claude Response")
                    st.markdown(result["claude_response"])
            else:
                st.error(result.get("error", "An error occurred during processing."))

# Footer information
st.markdown("---")
st.markdown("Developed with MCP and Claude API | Enables natural language queries to PostgreSQL")
