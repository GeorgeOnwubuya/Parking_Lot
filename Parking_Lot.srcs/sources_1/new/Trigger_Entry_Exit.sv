`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2019 10:24:03 AM
// Design Name: 
// Module Name: Trigger_Entry_Exit
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


module Trigger_Entry_Exit(
    input  logic clk,
    input  logic reset,
    input  logic sig_det1, sig_det2, 
    output logic enter,
    output logic exit
    );
    
    
    //Finite State Machine
    typedef enum logic[8:0]{WAIT_HLD  = 9'b000000001, ENTER1 = 9'b000000010, ENTER2 = 9'b000000100, ENTER3 = 9'b000001000, ENTER4 = 9'b000010000,
                            EXIT1     = 9'b000100000, EXIT2  = 9'b001000000, EXIT3  = 9'b010000000, EXIT4  = 9'b100000000}state_type;
                            
                            
    state_type curr_state, next_state;
    
    //Internal wires
    logic entry_signal, exit_signal;
    
    always_ff@(posedge clk, posedge reset) begin
        if(reset) begin
            curr_state <= WAIT_HLD;
        end
        else begin
            curr_state <= next_state;
        end
    end
    
    always_comb begin
        next_state = curr_state;
        entry_signal = 1'b0;
        exit_signal  = 1'b0;
        
        case(next_state) 
            WAIT_HLD: begin
                if(sig_det1 == 0) begin
                    next_state = ENTER1;
                end
                else if(sig_det2 == 0) begin
                    next_state = EXIT1;
                end
                else begin
                    next_state = WAIT_HLD;
                end
            end
            
            ENTER1: begin
                if(sig_det2 == 0) begin
                    next_state = ENTER2;
                end
                else if(sig_det1 == 1) begin
                    next_state = WAIT_HLD;
                end
                else begin
                    next_state = ENTER1;
                end
            end
            
            ENTER2: begin
                if(sig_det1 == 1) begin
                    next_state = ENTER3;
                end
                else if(sig_det2 == 1) begin
                    next_state = WAIT_HLD;
                end
                else begin
                    next_state = ENTER2;
                end
            end
            
            ENTER3: begin
                if(sig_det2 == 1) begin
                    next_state = ENTER4;
                end
                else if(sig_det1 == 0) begin
                    next_state = WAIT_HLD;
                end
                else begin
                    next_state = ENTER3;
                end
            end
            
            ENTER4: begin
                entry_signal = 1;
              	next_state = WAIT_HLD;
            end
            
            EXIT1: begin
                if(sig_det1 == 0) begin
                    next_state = EXIT2;
                end
                else if(sig_det2 == 1) begin
                    next_state = WAIT_HLD;
                end
                else begin
                    next_state = EXIT1;
                end
            end
            
            EXIT2: begin
                if(sig_det2 == 1) begin
                    next_state = EXIT3;
                end
                else if(sig_det1 == 1) begin
                    next_state = WAIT_HLD;
                end
                else begin
                   next_state = EXIT2; 
                end             
            end
            
            EXIT3: begin
                if(sig_det1 ==1) begin
                    next_state = EXIT4;
                end
                else if(sig_det2 == 0) begin
                    next_state = WAIT_HLD;
                end
                else begin
                    next_state = EXIT3;
                end
            end
            
            EXIT4: begin
                exit_signal = 1;
              	next_state = WAIT_HLD;
            end
			
          	default: begin
              	next_state = WAIT_HLD;
            end  
        endcase
    end
    
    assign enter = entry_signal;
    assign exit  = exit_signal;                       
endmodule
