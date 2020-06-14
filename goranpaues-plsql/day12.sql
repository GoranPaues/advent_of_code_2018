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
    type strings_aat is table of varchar2(200)
    index by pls_integer; 

    type code_aat is table of varchar2(1)
    index by varchar2(5);

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
        l_codes code_aat;
        l_line varchar2(200);
        l_current_codes strings_aat;
        l_next_line varchar2(200);
        l_current_code varchar2(5);
        l_total_count number := 0;
        l_index number := -18;
    begin
        select message bulk collect into l_strings from input;
        
        l_line := '....................' || substr(l_strings(1),16,length(l_strings(1))) || '....................';
        log(l_line);

        for c in 3..l_strings.last loop
            l_codes(substr(l_strings(c),1,5)) := substr(l_strings(c),10,1);
        end loop;
        
        for i in 1..20 loop
            l_current_codes.delete();
            l_current_codes(-20) := '.';
            l_current_codes(-19) := '.';
            l_index := -18;
            if l_next_line is not null then l_line := l_next_line; end if;
            l_next_line := '..';
            for c in 3..length(l_line)-2 loop
                if substr(l_line,c,1) = '#' then l_total_count := l_total_count + 1; end if;
                l_current_code := null;
                for d in (c-2)..(c+2) loop
                    l_current_code := l_current_code || substr(l_line,d,1);
                end loop;
                if not l_codes.exists(l_current_code)
                then l_current_codes(l_index) := '.';
                else l_current_codes(l_index) := l_codes(l_current_code);
                end if;
                l_next_line := l_next_line || l_current_codes(l_index);
                l_index := l_index + 1;
            end loop;
            l_next_line := l_next_line || '..';
            log(l_next_line);
        end loop;
        
        return l_total_count;
    end;
    
    function part2
    return varchar2
    is
        l_strings strings_aat;
        l_codes code_aat;
    begin
        select message bulk collect into l_strings from input;
        
        for c in l_strings.first..l_strings.last loop
            null;
        end loop;

        return 'true';
    end;

    procedure doit
    is    
    begin
        log('Part 1: ' || part1);
        log('Part 2: ' || part2);
    end;

end;
/

insert into input (message) values ('initial state: #..#.#..##......###...###')
/
insert into input (message) values ('...## => #')
/
insert into input (message) values ('..#.. => #')
/
insert into input (message) values ('.#... => #')
/
insert into input (message) values ('.#.#. => #')
/
insert into input (message) values ('.#.## => #')
/
insert into input (message) values ('.##.. => #')
/
insert into input (message) values ('.#### => #')
/
insert into input (message) values ('#.#.# => #')
/
insert into input (message) values ('#.### => #')
/
insert into input (message) values ('##.#. => #')
/
insert into input (message) values ('##.## => #')
/
insert into input (message) values ('###.. => #')
/
insert into input (message) values ('###.# => #')
/
insert into input (message) values ('####. => #')
/
/*
insert into input (message) values ('initial state: #.#..#.##.#..#.#..##.######...####.........#..##...####.#.###......#.#.##..#.#.###.#..#.#.####....##')
/
insert into input (message) values ('')
/
insert into input (message) values ('.#### => .')
/
insert into input (message) values ('.###. => .')
/
insert into input (message) values ('#.... => .')
/
insert into input (message) values ('##### => .')
/
insert into input (message) values ('..### => #')
/
insert into input (message) values ('####. => #')
/
insert into input (message) values ('..#.. => .')
/
insert into input (message) values ('###.# => .')
/
insert into input (message) values ('..##. => .')
/
insert into input (message) values ('#.##. => #')
/
insert into input (message) values ('#.#.. => .')
/
insert into input (message) values ('##... => .')
/
insert into input (message) values ('..#.# => #')
/
insert into input (message) values ('#.### => #')
/
insert into input (message) values ('.#..# => .')
/
insert into input (message) values ('#...# => #')
/
insert into input (message) values ('.##.# => #')
/
insert into input (message) values ('.#.#. => #')
/
insert into input (message) values ('#..#. => #')
/
insert into input (message) values ('###.. => #')
/
insert into input (message) values ('...#. => .')
/
insert into input (message) values ('.#.## => #')
/
insert into input (message) values ('.##.. => .')
/
insert into input (message) values ('#..## => .')
/
insert into input (message) values ('##.## => .')
/
insert into input (message) values ('.#... => #')
/
insert into input (message) values ('#.#.# => .')
/
insert into input (message) values ('##..# => .')
/
insert into input (message) values ('....# => .')
/
insert into input (message) values ('..... => .')
/
insert into input (message) values ('...## => #')
/
insert into input (message) values ('##.#. => .')
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
