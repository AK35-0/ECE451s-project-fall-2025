% Supporting function to save opened figures.
figs = findall(0, 'Type', 'figure');

for k = 1:length(figs)
    f = figs(k);
    name = get(f, 'Name');
    if isempty(name)
        name = sprintf('Figure_%d', f.Number);
    end

    name = matlab.lang.makeValidName(name);

    % savefig(f, name + ".fig");   % <-- best for later editing
    print(f, name + ".png", '-dpng', '-r300');  % save as png
end