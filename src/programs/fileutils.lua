function ls()
    local count = fcount()

    for i = 0, count - 1 do
        local fd = fopen(i)

        if fd then
            repeat
                local c = fgetc(fd)
                printf("%c", c)
            until c == charCode("\n")

            fclose(fd)
        end
    end
end

function cat(args)
    local fd = fopen(args)
    if fd == 0 then
        printf("Error: could not open file\n")
    else
        local c = 0
        repeat
            c = fgetc(fd)
            printf("%c", c)
        until c == 0

        if c ~= 10 then
            printf("\n")
        end

        fclose(fd)
    end
end

function write(args)
    local file, content = strsplit(args, charCode(" "))

    printf("Opening file %s\n", file)

    local fd = fopen(file)
    if fd == 0 then
        printf("Error: could not open file\n")
    else
        printf("Writing content...\n")
        for i = 1, #content do
            fwrite(fd, content[i])
        end
        fwrite(fd, 0)
        fclose(fd)
    end
end

function no_directories()
    terminal_static_writeln("There is only one directory you fool")
end