// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2019 09:29:27 AM
// Design Name: 
// Module Name: Parking_Lot_tb
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


module Parking_Lot_tb();
  
  	localparam N = 32;

    logic clk = 0;
    logic reset = 1;
  	logic set = 0;
    logic SD1, SD2;
    logic err_out;
    logic [$clog2(N):0]car_count = 0;
  	logic [$clog2(N):0]num_cars;
    
  	Counter dut(.*);

    always begin
        #5;
        clk = ~clk;
    end
    
    task automatic Car_Enter(ref logic clk, SD1, SD2); 
        SD1 = 0;
        repeat(3) @(posedge clk);
        SD2 = 0;
        repeat(3) @(posedge clk);
        SD1 = 1;
        repeat(3) @(posedge clk);
        SD2 = 1; 
    endtask
    
    task automatic Car_Exit(ref logic clk, SD1, SD2);
        SD2 = 0;
        repeat(3) @(posedge clk);
        SD1 = 0;
        repeat(3) @(posedge clk);
        SD2 = 1;
        repeat(3) @(posedge clk);
        SD1 = 1;    
    endtask
  
  	task automatic Car_Enter_Exit(ref logic clk, SD1, SD2);
      	repeat(1) begin
            repeat(2)@(posedge clk);
            Car_Enter(clk, SD1, SD2);
        end
        
      	repeat(2)@(posedge clk);
      	
      	repeat(2) begin
          	repeat(2)@(posedge clk);
            Car_Exit(clk, SD1, SD2);
        end
      	
      	repeat(2)@(posedge clk);
      
      	repeat(0) begin
          	repeat(2)@(posedge clk);
            Car_Enter(clk, SD1, SD2);
        end
      
      	repeat(2)@(posedge clk);
      
      	repeat(0) begin
          	repeat(2)@(posedge clk);
            Car_Exit(clk, SD1, SD2);
        end
      
      	repeat(2)@(posedge clk);
      	
    endtask
    
  	task automatic Error_Test1(ref logic clk, SD1, SD2);
    	SD1 = 0;
        repeat(3) @(posedge clk);
        SD2 = 1;
        repeat(3) @(posedge clk);
        SD1 = 1;
        repeat(3) @(posedge clk);
        SD2 = 1;   	  	
    endtask;
  
  task automatic Error_Test2(ref logic clk, SD1, SD2);
    	SD1 = 1;
        repeat(3) @(posedge clk);
        SD2 = 0;
        repeat(3) @(posedge clk);
        SD1 = 1;
        repeat(3) @(posedge clk);
        SD2 = 1;   	  	
    endtask;
    
    initial begin
      	//$dumpfile("dump.vcd");
      	//$dumpvars;
        SD1 = 1;
        SD2 = 1;
      
      	repeat(2)@(posedge clk);
        reset = 0;
      	//Car_Enter_Exit(clk, SD1, SD2);
      	//repeat(2)@(posedge clk);
      	Error_Test1(clk, SD1, SD2);
      	repeat(2)@(posedge clk);
      	Error_Test2(clk, SD1, SD2);
      	repeat(2)@(posedge clk);
      	$finish;
    end
endmodule
