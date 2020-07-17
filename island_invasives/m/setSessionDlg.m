function ansSession = setSessionDlg(ansSession)
dim = [7 3];

Title = 'Grupo de Ecología y Conservación de Islas, A.C.';

% static text
Prompt = cell(1,2);
Prompt{1,1} = ['Analysis of Aerial Rodenticide Dispersal'];
Formats(1,1).type = 'text';
Formats(1,1).style = 'text';
Formats(1,1).size = [-1 -1];
for k = 2:dim(2) % span the static text across the entire dialog
    Formats(1,k).type = 'none';
    Formats(1,k).limits = [0 1]; % extend from left
end

Prompt(2,:) = {'Name of the site or event', 'Name'};
Formats(2,1).type = 'edit';
Formats(2,1).format = 'text';
Formats(2,1).size = min((length(ansSession.SessionFile)*8),700);
for k = 2:dim(2) % span the file edit
    Formats(2,k).type = 'none';
    Formats(2,k).limits = [0 1]; % extend from left
end

Prompt(3,:) = {'Session file','SessionFile'};
Formats(3,1).type = 'edit';
Formats(3,1).format = 'file';
Formats(3,1).items = {'*_nerd.mat','Numerical Estimation of Rodenticide Dispersal (*_nerd.mat)';'*.*','All Files'};
Formats(3,1).limits = [1 0]; % use uiputfile
Formats(3,1).size = [-1 -1];
for k = 2:dim(2) % span the file edit
    Formats(3,k).type = 'none';
    Formats(3,k).limits = [0 1]; % extend from left
end

Prompt(4,:) = {'Width of the dispersal stripe (m)', 'StripeWidth'};
Formats(4,1).type = 'edit';
Formats(4,1).format = 'integer';
Formats(4,1).limits = [0 99]; % 2-digits (positive #)
Formats(4,1).size = 50;

%%%% SETTING DIALOG OPTIONS
Options.WindowStyle = 'modal';
Options.Resize = 'on';
Options.Interpreter = 'tex';


%%%% SETTING DEFAULT STRUCT
DefAns.Name              = ansSession.Name;
DefAns.SessionFile       = ansSession.SessionFile;
DefAns.StripeWidth       = ansSession.StripeWidth;

%%%% GETTING ANSWER STRUCT
[Answer,Cancelled] = inputsdlg(Prompt,Title,Formats,DefAns,Options);
ansSession.Name              = Answer.Name;
ansSession.SessionFile       = Answer.SessionFile;
ansSession.StripeWidth       = Answer.StripeWidth;

%%%% Define class intervals
rho=30; % Densidad objetivo
clases = [1 floor((1/3)*rho) round(rho-.1*rho) round(rho+.1*rho) ceil(2*rho)];
n=length(clases);
for i=1:n
    prompt{i}  = ['Minimum of class interval ' num2str(i) ':'] ;
    default{i} = [num2str(clases(i))];
end

title = 'Define class intervals';
num_lines = 1;
answer = inputdlg(prompt,title,num_lines,default);
ansSession.ClassIntervals=unique(str2num(char(answer)));
