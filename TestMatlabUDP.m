% Script to test the function ConnectTCP.m 
% Author: Felix Dollack (c) TGM @ Jade Hochschule applied licence see EOF 
% Version History:
% Ver. 0.01 initial create (empty) 27-Nov-2014 			 FD

clear;
close all;
clc;

%------------Your script starts here--------
sender_args.port    = 4245; % port which the android device addresses
sender_args.timeout = 2000; % time (in ms) to wait for a connection (per try)

sender_args.port    = 4245; % port which the android device addresses
reader_args.ip      = '139.13.130.197'; % IP to send the message to
sender_args.timeout = 5000; % time (in ms) to wait for a connection (per try)

% create UDP object and get function handles
sender   = MatlabUDP( sender_args );
receiver = MatlabUDP( reader_args );

sender.write( 'Hello Server!' ); % send message to server

msg = receiver.read();             % send message to server
disp( msg );

%--------------------Licence ---------------------------------------------
% Copyright (c) <2014> Felix Dollack
% Jade University of Applied Sciences 
% Permission is hereby granted, free of charge, to any person obtaining 
% a copy of this software and associated documentation files 
% (the "Software"), to deal in the Software without restriction, including 
% without limitation the rights to use, copy, modify, merge, publish, 
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject
% to the following conditions:
% The above copyright notice and this permission notice shall be included 
% in all copies or substantial portions of the Software.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.