module register_random_test1;
timeunit 1ns;
timeprecision 100ps;

logic [7:0]   out  ;
logic [7:0]   data ;
logic         enable  ;
logic         rst_ = 1'b1;
logic         clk = 1'b1;

`define PERIOD 10

always
    #(`PERIOD/2) clk = ~clk;

// INSTANCE register 
 register r1 (.enable(enable), .clk(clk), .out(out), .data(data), .rst_(rst_));

  // Monitor Results
  initial
    begin
     $timeformat ( -9, 1, " ns", 9 );
     $monitor ( "time=%t enable=%b rst_=%b data=%h out=%h",
	        $time,   enable,   rst_,   data,   out );
     #(`PERIOD * 99)
     $display ( "REGISTER TEST TIMEOUT" );
     $finish;
    end

// Verify Results
  task expect_test (input [7:0] expects) ;
    if ( out !== expects )
      begin
        $display ( "out=%b, should be %b", out, expects );
        $display ( "REGISTER TEST FAILED" );
        $finish;
      end
  endtask

  initial
    begin
      @(negedge clk)
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data); // enable is high so data should be written to register at posedge
      rst_ = 1'b0;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (8'b0); // rst_ is low so register should now store 8'b0
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data); // enable is high so data should be written to register at posedge      
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data); // ..
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data); // ..
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data);
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data);
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data);
      rst_ = 1'b0;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (8'b0); // rst_ is low so register should now store 8'b0
      rst_ = 1'b1;  enable = 1'b0;  data = $random % 8'hFF; @(negedge clk) expect_test (8'b0); // enable is low so register should contain the previous (8'b0) value
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data); // enable is high so data should be written to register at posedge 
      rst_ = 1'b1;  enable = 1'b1;  data = $random % 8'hFF; @(negedge clk) expect_test (data); // ..

      $display ( "REGISTER TEST PASSED" );
      $finish;
    end
endmodule
