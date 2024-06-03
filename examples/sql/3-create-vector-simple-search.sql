--Create Index for Vectors
 CREATE VECTOR INDEX vectab_vidx ON vectab (vector) ORGANIZATION NEIGHBOR PARTITIONS;
--simple PL/SQL search but can be rest, apex, etc. as exposed. 
declare 
    vec vector;
    query varchar2(128) := 'embedding';
    ans varchar2(256);
    
    cursor c_t2 is
        select chunk
        from vectab
        order by vector_distance(vector, vec, cosine)
        fetch first 5 rows only;

begin

    dbms_output.put_line('Similiarity Search using PL/SQL and vector_embedding');
    dbms_output.put_line('====================================================');
    dbms_output.put_line('');
    
    select vector_embedding(doc_model using query as data) into vec;
    
    dbms_output.put_line(to_char(vec));
    
    for item in c_t2
    loop
        dbms_output.put_line('======item======');
        dbms_output.put_line(item.chunk);
    end loop;
end;
