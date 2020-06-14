create table input
( 
  id number generated always as identity,
  message varchar2(200)
)
/

create table output
(   
  id number generated always as identity,
  message varchar2(200)
)
/

create or replace package pkg_advcode
is
    TYPE strings_aat IS TABLE OF varchar2(200)
    INDEX BY PLS_INTEGER; 

    TYPE x_aat IS TABLE OF number
    INDEX BY PLS_INTEGER;    
    TYPE coordinates_aat IS TABLE OF x_aat
    INDEX BY PLS_INTEGER; 
    
    procedure doit;
end;
/

create or replace package body pkg_advcode
is
    procedure log(p_message in varchar)
    is
    begin
        insert into output(message) values (p_message);
    end;

    function part1
    return number
    is
        l_strings strings_aat;
        l_points coordinates_aat;
        l_finite coordinates_aat;
        l_destinations coordinates_aat;
        l_x pls_integer := 0;
        l_y pls_integer := 0;
        l_min_x number := 0;
        l_max_x number := 0;
        l_min_y number := 0;
        l_max_y number := 0;
        l_start_x number := 0;
        l_start_y number := 0;
        l_index number := 0;
        l_closest boolean := false;
    begin
    
        select min(x), max(x),min(y),max(y)
        into l_min_x, l_max_x, l_min_y, l_max_y
        from (select substr(message,1,instr(message,',')) x,
                     substr(message,instr(message,',')+2,length(message)) y
                from input);
        --log(l_min_x || ' ' || l_max_x || ' ' || l_min_y || ' ' || l_max_y);
        select message bulk collect into l_strings from input;
        
        for indx in l_strings.first..l_strings.last loop
            l_x := substr(l_strings(indx),1,instr(l_strings(indx),','));
            l_y := substr(l_strings(indx),instr(l_strings(indx),',')+2,length(l_strings(indx)));
            l_points(l_x)(l_y) := 0;
            if l_x > l_min_x and l_x < l_max_x and l_y > l_min_y and l_y < l_max_y 
            then 
                l_finite(l_x)(l_y) := 0;
            end if;
        end loop;
        l_index := l_finite.first;
        while l_index is not null loop
            l_x := l_index;
            l_y := l_finite(l_index).first;
            --log( l_x || ' ' || l_y);
            loop 
                exit when l_x = l_min_x ;
                log(l_x || ', ' || l_y);
                loop
                    exit when l_y = l_min_y;
                    log(l_x || ', ' || l_y);
                    l_y := l_y - 1 ;
                end loop;
                l_x := l_x - 1;
                l_y := l_finite(l_index).first;
            end loop;
            l_index := l_finite.next(l_index);
        end loop;
        return 0;
    end;

    function part2
    return number
    is
        l_strings strings_aat;
        l_result number := 0;        
    begin
        select message bulk collect into l_strings from input;
        return l_result;
    end;

    procedure doit
    is    
    begin
        log('Part 1: ' || part1);
        log('Part 2: ' || part2);
    end;

end;
/

insert into input (message) values ('1, 1')
/
insert into input (message) values ('1, 6')
/
insert into input (message) values ('8, 3')
/
insert into input (message) values ('3, 4')
/
insert into input (message) values ('5, 5')
/
insert into input (message) values ('8, 9')
/

/*
insert into input (message) values ('67, 191')
/
insert into input (message) values ('215, 237')
/
insert into input (message) values ('130, 233')
/
insert into input (message) values ('244, 61')
/
insert into input (message) values ('93, 93')
/
insert into input (message) values ('145, 351')
/
insert into input (message) values ('254, 146')
/
insert into input (message) values ('260, 278')
/
insert into input (message) values ('177, 117')
/
insert into input (message) values ('89, 291')
/
insert into input (message) values ('313, 108')
/
insert into input (message) values ('145, 161')
/
insert into input (message) values ('143, 304')
/
insert into input (message) values ('329, 139')
/
insert into input (message) values ('153, 357')
/
insert into input (message) values ('217, 156')
/
insert into input (message) values ('139, 247')
/
insert into input (message) values ('304, 63')
/
insert into input (message) values ('202, 344')
/
insert into input (message) values ('140, 302')
/
insert into input (message) values ('233, 127')
/
insert into input (message) values ('260, 251')
/
insert into input (message) values ('235, 46')
/
insert into input (message) values ('357, 336')
/
insert into input (message) values ('302, 284')
/
insert into input (message) values ('313, 260')
/
insert into input (message) values ('135, 40')
/
insert into input (message) values ('95, 57')
/
insert into input (message) values ('227, 202')
/
insert into input (message) values ('277, 126')
/
insert into input (message) values ('163, 99')
/
insert into input (message) values ('232, 271')
/
insert into input (message) values ('130, 158')
/
insert into input (message) values ('72, 289')
/
insert into input (message) values ('89, 66')
/
insert into input (message) values ('94, 111')
/
insert into input (message) values ('210, 184')
/
insert into input (message) values ('139, 58')
/
insert into input (message) values ('99, 272')
/
insert into input (message) values ('322, 148')
/
insert into input (message) values ('209, 111')
/
insert into input (message) values ('170, 244')
/
insert into input (message) values ('230, 348')
/
insert into input (message) values ('112, 200')
/
insert into input (message) values ('287, 55')
/
insert into input (message) values ('320, 270')
/
insert into input (message) values ('53, 219')
/
insert into input (message) values ('42, 52')
/
insert into input (message) values ('313, 205')
/
insert into input (message) values ('166, 259')
/
*/

-- Execution
begin
    pkg_advcode.doit;
end;
/

-- Print result
select message
from   output
order by id
/

drop table input purge
/

drop table output purge
/
