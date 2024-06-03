drop table demo_tab;
create table demo_tab (id number, data blob);
insert into demo_tab values(2, to_blob(bfilename('DM_DUMP', 'oracle-ai-vector-search-users-guide.pdf')));
commit;
--generate chunks and vectors using in-database model
var chunk_params clob;
exec :chunk_params := '{"by":"words", "max": "50", "split":"sentence", "normalize":"all"}';

var embed_params clob;
exec :embed_params := '{"provider":"database", "model":"doc_model"}';

create table vectab as (
    select dt.id docid,
    et.embed_id chunk_id,
    et.embed_data chunk,
    to_vector(et.embed_vector) vector
from demo_tab dt,
dbms_vector_chain.utl_to_embeddings(dbms_vector_chain.utl_to_chunks(dbms_vector_chain.utl_to_text(dt.data), json('{"normalize":"all"}')),
     json('{"provider":"database", "model":"doc_model"}')) t,
     json_table(t.column_value, '$[*]' columns (
        embed_id number path '$.embed_id',
        embed_data varchar2(4000) path '$.embed_data',
        embed_vector clob path '$.embed_vector')) et
);