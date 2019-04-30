`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2019 11:41:47 AM
// Design Name: 
// Module Name: Counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Counter #(parameter N = 32) //N = (number of parking spots + cars circling in parking area)
    (
        input  logic clk,
        input  logic reset, set,
        input  logic SD1, SD2,
        input  logic [$clog2(N):0]car_count,
      	output logic [$clog2(N):0]num_cars,
        output logic err_out
    );
   
    //Signals
    logic inc, dec;               //increment, decrement counter
    logic error, next_error;     //error flag
    logic [$clog2(N):0]count, next_count;
    
       
    always_ff@(posedge clk, posedge reset) begin
        if(reset) begin
            error <= 0;
        end
        else begin
            error <= next_error;
        end        
    end
    
    always_ff@(posedge clk, posedge reset) begin
        if(reset) begin
            count <= 0;
        end
        else begin
            count <= next_count;
        end
    end
    
    always_comb begin
        next_count = count;
        next_error = error;
        if(inc) begin
          if(count == 32) begin
                next_error = 1;
                next_count = count;
            end
            else begin
                next_error = error;
                next_count = count + 1;
            end
        end
        
        else if(dec) begin
            if(count == 0) begin
                next_error = 1;
                next_count = count;
            end
            else begin
                next_error = error;
                next_count = count - 1;
            end
        end
        
        else if(set) begin
            next_count = car_count;
        end
        
      	else begin
          	next_count = count;
          	next_error = error;
        end  
    end
    
    assign num_cars = count;
    assign err_out = error;
    
    Trigger_Entry_Exit trigger(
    .clk(clk),
    .reset(reset),
    .sig_det1(SD1),
    .sig_det2(SD2),
    .enter(inc),
    .exit(dec)
    );   
endmodule
