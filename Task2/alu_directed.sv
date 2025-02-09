// Directed testbench for ALU
`timescale 1ns/100ps

module alu_directed;
    // Signal declarations
    logic [7:0] a, b, out;
    logic clk, zero;
    opcode_t opcode;

    // Instantiate the ALU
    alu dut (
        .out(out),
        .zero(zero),
        .clk(clk),
        .a(a),
        .b(b),
        .opcode(opcode)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test task
    task test_alu(
        input opcode_t op,
        input [7:0] in_a,
        input [7:0] in_b,
        input [7:0] expected
    );
        @(posedge clk);
        opcode = op;
        a = in_a;
        b = in_b;
        @(negedge clk);
        @(negedge clk); // Wait for result
        
        if(out !== expected) begin
            $display("Error: %s test failed", op.name());
            $display("Inputs: a=%h, b=%h", in_a, in_b);
            $display("Expected: %h, Got: %h", expected, out);
        end else begin
            $display("Success: %s test passed", op.name());
        end
        
        // Check zero flag
        if(out == 0 && !zero) begin
            $display("Error: Zero flag not set when out is zero");
        end else if(out != 0 && zero) begin
            $display("Error: Zero flag set when out is not zero");
        end
    endtask

    // Main test sequence
    initial begin
        $display("Starting ALU Directed Tests");
        
        // Test each operation with specific values
        test_alu(ADD, 8'h05, 8'h03, 8'h08);  // 5 + 3 = 8
        test_alu(SUB, 8'h05, 8'h03, 8'h02);  // 5 - 3 = 2
        test_alu(OR,  8'h05, 8'h03, 8'h0F);  // 5 * 3 = 15 
        test_alu(AND, 8'h05, 8'h03, 8'h07);  // 5 | 3 = 7 
        test_alu(XOR, 8'h05, 8'h03, 8'h01);  // 5 & 3 = 1 
        test_alu(SLL, 8'h05, 8'h03, 8'h06);  // 5 ^ 3 = 6 
        test_alu(SRL, 8'h08, 8'h01, 8'h10);  // 8 << 1 = 16 
        test_alu(SLT, 8'h08, 8'h01, 8'h04);  // 8 >> 1 = 4 

        // Test zero flag
        test_alu(SUB, 8'h05, 8'h05, 8'h00);  // 5 - 5 = 0 (should set zero flag)
        
        $display("ALU Directed Tests Completed");
        $finish;
    end

endmodule