/* Keys.sql - use the primary key constraint information in the
 * database to build the sp_primarykey information.
 */
use kardia
go

declare _c cursor for select name, id from sysobjects where type = 'U'
go

open _c
create table #tmptable (id int, name varchar(32))
go

declare @name varchar(30)
declare @id int
declare @keystr varchar(255)
declare @len int
declare @len2 int
declare @len3 int
declare @colid int
declare @n1 varchar(30)
declare @n2 varchar(30)
declare @n3 varchar(30)
declare @n4 varchar(30)
declare @n5 varchar(30)
declare @n6 varchar(30)
fetch _c into @name, @id

while @@sqlstatus = 0
    begin
        select @name
        select @len = char_length(convert(varchar(255),keys1)), @keystr = convert(varchar(255),keys1) from sysindexes where id = @id and name like '%PK'
	if @@rowcount = 1
	    begin
	        delete from #tmptable
		select @len3 = 0
	        select @len2 = @len / 16
		while @len >= 16
		    begin
		        select @colid = ascii(substring(@keystr,3,1))
			if @colid > 0 
			    begin
			    insert into #tmptable select @len2 - (@len/16 - 1), name from syscolumns where id = @id and colid = @colid
			    select @len3 = @len3 + 1
			    end
			select @keystr = substring(@keystr,17,255)
			select @len = @len - 16
		    end
		select * from #tmptable
		exec sp_dropkey primary,@name
		if @len3 = 1
		    begin
		        select @n1 = name from #tmptable where id = 1
		        exec sp_primarykey @name, @n1
		    end
		else if @len3 = 2
		    begin
		        select @n1 = name from #tmptable where id = 1
		        select @n2 = name from #tmptable where id = 2
		        exec sp_primarykey @name, @n1, @n2
		    end
		else if @len3 = 3
		    begin
		        select @n1 = name from #tmptable where id = 1
		        select @n2 = name from #tmptable where id = 2
		        select @n3 = name from #tmptable where id = 3
		        exec sp_primarykey @name, @n1, @n2, @n3
		    end
		else if @len3 = 4
		    begin
		        select @n1 = name from #tmptable where id = 1
		        select @n2 = name from #tmptable where id = 2
		        select @n3 = name from #tmptable where id = 3
		        select @n4 = name from #tmptable where id = 4
		        exec sp_primarykey @name, @n1, @n2, @n3, @n4
		    end
		else if @len3 = 5
		    begin
		        select @n1 = name from #tmptable where id = 1
		        select @n2 = name from #tmptable where id = 2
		        select @n3 = name from #tmptable where id = 3
		        select @n4 = name from #tmptable where id = 4
		        select @n5 = name from #tmptable where id = 5
		        exec sp_primarykey @name, @n1, @n2, @n3, @n4, @n5
		    end
		else if @len3 = 6
		    begin
		        select @n1 = name from #tmptable where id = 1
		        select @n2 = name from #tmptable where id = 2
		        select @n3 = name from #tmptable where id = 3
		        select @n4 = name from #tmptable where id = 4
		        select @n5 = name from #tmptable where id = 5
		        select @n6 = name from #tmptable where id = 6
		        exec sp_primarykey @name, @n1, @n2, @n3, @n4, @n5, @n6
		    end
	    end
        fetch _c into @name, @id
    end

close _c
go

deallocate cursor _c
go
