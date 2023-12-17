inputs = [-2 1; 0 1; 2 -1; -2 -1];
target_outputs = [0; 0; 1; 0];

w = [-3; 3];
s = 3;

n = 0.1;
max_error = 0.01;

for epoch = 1:100
    te = 0;

    for i = 1:size(inputs, 1)
        af = @(x) double(x >= 0);
        output = af(inputs(i, :) * w + s);
        
        error = target_outputs(i) - output;
        te = te + abs(error);
        
        w = w + n * error * inputs(i, :)';
        s = s + n * error;
    end
    
    av = te / size(inputs, 1);
    disp(['Epoch ' num2str(epoch) ', Average error: ' num2str(av)]);
    
    if av < max_error
        break;
    end
end

disp('Итоговые веса:');
disp(w);
disp(['Итоговое смещение: ', num2str(s)]);