# MatlabUDP

## Synopsis
**This class contains methods to read and write UDP packages between Matlab and any other network device. The core function 'MatlabUDP()' provides handles to communicate in a more comfortable way.**

## Usage
__MatlabUDP__ can be called without parameters. The defaults can be changed trough input parameters (see list [below](#parameters)).
__TestMatlabUDP__ is the example script to test __MatlabUDP()__. You have to run two instances of Matlab because the read method blocks until a message is received or the timeout is passed.
To be able to send a message you have to specify an ip address. A reader instance needs at least a specific port to listen on.

### Examples:
```Matlab
% without input parameters the defaults will be used
network_object = MatlabUDP();

% input parameters as struct with fieldnames equal to parameters
in_args.ip                  = '192.168.138.11';
in_args.port                = 4245;
in_args.timeout             = 2000;
in_args.max_message_length  = 1024;

network_object  = MatlabUDP( in_args );

% input parameters specified as single or multiple arguments.
network_object = MatlabUDP( 'ip', '192.168.138.11' );
network_object = MatlabUDP( 'ip', '192.168.138.11', 'port', 4245 );
network_object = MatlabUDP( 'ip', '192.168.138.11', 'port', 4245, 'timeout', 2000 );
network_object = MatlabUDP( 'ip', '192.168.138.11', 'port', 4245, 'timeout', 2000, 'max_message_length', 1024 );
```

## Parameters
```Matlab
%   Possible function input parameters:
%   ------------------------------------
%
%   'ip':                   ip specifies the address of the host
%                           (default is '')
%
%   'port':                 port to listen for incoming UDP packets
%                           (default is 4245)
%
%   'timeout':              time in milliseconds to wait for an incoming packet
%                           (default is 2000)
%
%   'max_message_length':   maximal length of an incoming packet
%                           (default is 1024)
'''