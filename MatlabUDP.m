classdef MatlabUDP < handle
    % class to connect and communicate via UDP protocol
    % Usage network_object = MatlabUDP( varargin )
    % Input Parameter:
    %	 varargin: 		 input parameters must be given as parameter pairs
    %                    or as struct
    % Output Parameter:
    %	 network_object: an object with public methods to communicate via
    %                    UDP network protocol
    %------------------------------------------------------------------------ 
    % Example: network_object = MatlabUDP();

    % Author: Felix Dollack (c) TGM @ Jade Hochschule applied licence see EOF 
    % Source: Kevin Bartlett
    % (http://www.mathworks.com/matlabcentral/fileexchange/
    %  24525-a-simple-udp-communications-application/content/judp.m)
    % Version History:
    % Ver. 0.01 initial create (empty)              27-Nov-2014  FD
    % Ver. 0.02 rewrote Bartletts judp.m as class   27-Nov-2014  FD

    properties( Access = public ),
        ip;
        port;
        timeout;
        maximum_message_len;
    end
    properties( Access = private ),
        host;
    end
    
    properties( Access = private ),
        % define input parameter names and default values:
        param_name        = { 'ip', 'port', 'timeout', 'max_message_length' };
        param_default     = {   '',   4245,      2000,                 1024 };
    end
    
    methods( Access = public ),
        function self = MatlabUDP( varargin )
            % create parser object:
            inParser = inputParser;
            inParser.CaseSensitive = false; % no capital writing is required
            inParser.StructExpand  = true;  % allow structs to be function input
            addOptional( inParser, self.param_name{ 1 }, self.param_default{ 1 }, @(x) ischar( x )&&( length( find( x == '.' ))==3 ));
            addOptional( inParser, self.param_name{ 2 }, self.param_default{ 2 }, @(x) isnumeric( x )&&( x>0 )&&( x < 2^15 ));
            addOptional( inParser, self.param_name{ 3 }, self.param_default{ 3 }, @(x) isnumeric( x )&&( x>0 ));
            addOptional( inParser, self.param_name{ 4 }, self.param_default{ 4 }, @(x) isnumeric( x )&&( x>0 ));
            
            % check given parameters and throw an error if there are any mistakes
            parse( inParser, varargin{ : });
            
            self.ip                  = inParser.Results.ip;
            self.port                = inParser.Results.port;
            self.timeout             = inParser.Results.timeout;
            self.maximum_message_len = inParser.Results.max_message_length;
        end
        
        function write( self, message )
            % import java packets to get socket access
            import java.io.*
            import java.net.DatagramSocket
            import java.net.DatagramPacket
            import java.net.InetAddress
            try
                if( ~isa( message, 'int8' )),
                    message = int8( message );
                end
                self.host = InetAddress.getByName( self.ip );
                data = DatagramPacket( message, length( message ), self.host, self.port );
                socket = DatagramSocket;
                socket.setReuseAddress( 1 );
                socket.send( data );
                socket.close;
            catch send_packet_error,
                try
                    socket.close;
                catch close_error,
                    % do nothing
                end
                self.show_error( '', send_packet_error );
            end
        end
        
        function varargout = read( self )
            % import java packets to get socket access
            import java.io.*
            import java.net.DatagramSocket
            import java.net.DatagramPacket
            import java.net.InetAddress
            try
                socket = DatagramSocket( self.port );
                socket.setSoTimeout( self.timeout );
                socket.setReuseAddress( 1 );
                in_buffer = DatagramPacket( zeros( 1, self.maximum_message_len, 'int8' ), self.maximum_message_len );
                socket.receive( in_buffer );
                socket.close;
                data = in_buffer.getData;
                data = data( 1:in_buffer.getLength );
                remote_host = in_buffer.getAddress;
                remote_ip = char( remote_host.getHostAddress );
                varargout{ 1 } = char( data )';
                if( nargout > 1 ),
                    varargout{ 2 } = remote_ip;
                end
            catch receive_error,
                if( ~ isempty( strfind( receive_error.message, 'java.net.SocketTimeoutException' ))),
                    self.show_error( 'Failed to receive UDP packet. Connection timed out.' );
                else
                    self.show_error( 'Failed to receive UDP packet.', receive_error );
                end
            end
        end
    end
    
    methods( Access = private ),
        function show_error( self, my_error_message, java_exception )
            if( nargin < 3 )
                error( '%s.m - %s\n', mfilename, my_error_message );
            else
                error( '%s.m - %s\nJava error message follows:\n%s', ...
                    mfilename, my_error_message, java_exception.message );
            end
        end
    end
end
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