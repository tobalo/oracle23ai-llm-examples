begin
    -- Allow all hosts for HTTP/HTTP_PROXY
    dbms_network_acl_admin.append_host_ace(
        host =>'*',
        lower_port => 11434,
        upper_port => 11434,
        ace => xs$ace_type(
        privilege_list => xs$name_list('http', 'http_proxy'),
        principal_name => upper('ANALYST'),
        principal_type => xs_acl.ptype_db)
    );
    -- Allow wallet access
    dbms_network_acl_admin.append_wallet_ace(
        wallet_path => 'file:/opt/oracle/dcs/commonstore/wallets/ssl',
        ace => xs$ace_type(privilege_list =>
        xs$name_list('use_client_certificates', 'use_passwords'),
        principal_name => upper('ANALYST'),
        principal_type => xs_acl.ptype_db)
    );
end;
/

--Now I’m calling the private ip on the RED Device the VM of the LLM service private ip restful endpoint.
SELECT
    dbms_vector.utl_to_embedding(
        'hello world',
        json('{
            "provider": "ollama",
            "host": "local",
            "url": "http://IP:11434/api/embeddings",
            "model": "llama3"
        }')
    )
FROM dual;
