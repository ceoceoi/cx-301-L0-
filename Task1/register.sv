 `timescale 1ns/1ps
module register( 
 input logic clk,
 input logic rst_,
 input logic enable,
 input logic [7:0]data,
 
 output logic [7:0]out );
   

 always @ (posedge clk,  negedge rst_)
    begin
    if (rst_ == 0) 
    out<=1'b0 ;
    else if (enable)
    out<=data;
    
    end



endmodule
