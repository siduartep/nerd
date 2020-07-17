function ansOutput = setOutputDlg(ansOutput)
dim = [15 3];

Title = 'Grupo de Ecología y Conservación de Islas, A.C.';

% static text
Prompt = cell(1,2);
Prompt{1,1} = ['The results will be exported in Shapefile format to this folder'];
Formats(1,1).type = 'text';
Formats(1,1).style = 'text';
Formats(1,1).size = 600;

Formats(1,1).size = [-1 0];
for k = 2:dim(2) % span the static text across the entire dialog
   Formats(1,k).type = 'none';
   Formats(1,k).limits = [0 1]; % extend from left
end

Prompt(end+1,:) = {'Output folder','OutputFolder'};
Formats(2,1).type = 'edit';
Formats(2,1).format = 'dir';
Formats(2,1).size = 800;

for k = 2:dim(2) % span the file edit
   Formats(2,k).type = 'none';
   Formats(2,k).limits = [0 1]; % extend from left
end

%%%% SETTING DIALOG OPTIONS
Options.WindowStyle = 'modal';
Options.Resize = 'on';
Options.Interpreter = 'tex';


%%%% SETTING DEFAULT STRUCT

DefAns.OutputFolder = ansOutput.OutputFolder;
[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);
ansOutput.OutputFolder=Answer.OutputFolder;
