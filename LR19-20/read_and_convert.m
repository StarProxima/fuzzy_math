function lists = read_and_convert(filename)
    % Открытие файла для чтения
    fid = fopen(filename, 'rt');
    
    % Проверка, что файл был успешно открыт
    if fid == -1
        error('Не удалось открыть файл.');
    end
    
    % Инициализация пустого списка
    lists = {};

    % Чтение файла построчно
    tline = fgetl(fid);
    while ischar(tline)
        % Преобразование строки в числа и добавление в список
        numbers = str2num(tline); %#ok<ST2NM>
        if ~isempty(numbers)
            lists{end+1} = numbers;
        end
        
        % Чтение следующей строки
        tline = fgetl(fid);
    end

    % Закрытие файла
    fclose(fid);
end
