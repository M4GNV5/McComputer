function ls()
    local count = fcount()

    for i = 0, count - 1 do
        local fd = fopen(i)

        if fd then
            local c = fgetc(fd)
            repeat
                printf("%c", c)
                c = fgetc(fd)
            until c == charCode("\n")
            fclose(fd)
        end
        printf(" ")
    end
    printf("\n")
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

    local fd = fopen(file)
    if fd == 0 then
        printf("Creating file...\n")
        fd = fcreate(file)
    end

    printf("Writing content...\n")
    for i = 1, #content do
        fwrite(fd, content[i])
    end
    fwrite(fd, 0)
    fclose(fd)
end
