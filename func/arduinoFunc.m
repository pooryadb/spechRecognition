% code & research by : PDB

%
%   send command to hardware and get response
function [msg,state] = arduinoFunc(port,command)
%   port	(stirng):        portnumber (like 'com9')
%   command	(string):        "open" / "close"
%   return
%           msg (string):   response from arduino or error message
%           state (int):    1=success / 0=fail
try
    delete(instrfind({'Port'},{port}));
    PS=serial(port);
    set(PS,'Baudrate',9600); % 9600 Baud rate
    set(PS,'StopBits',1);
    set(PS,'DataBits',8);
    set(PS,'Parity','none');
    set(PS,'Terminator','CR/LF'); % end character
    set(PS,'OutputBufferSize',8);
    set(PS,'InputBufferSize' ,8);
    set(PS,'Timeout',5); % 5 seconds waite for response
    
    fopen(PS);
catch
    msg = "Opening port error";
    state = 0;
    return;
end

pause(1.8);

fprintf(PS, "%s" , command);


load = fscanf(PS, '%s');

fclose(PS); %important
delete(PS);
clear PS;

if isempty(load)
    msg = "No connection !";
    state = 0;
end

msg = load ;
state = 1;

