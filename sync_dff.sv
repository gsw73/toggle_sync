module sync_dff
#(
    parameter WIDTH = 8
)
(
    input logic clk,
    input logic rst_n,
    input logic [ WIDTH - 1:0 ] sig_in,
    output logic [ WIDTH - 1:0 ] sig_out
);

// =======================================================================
// Declarations & Parameters
  
logic [ WIDTH - 1:0 ] sig_in_q;
logic [ WIDTH - 1:0 ] sig_in_qq;

// =======================================================================
// Logic

assign sig_out = sig_in_qq;
  
always_ff @( posedge clk )

    if ( !rst_n )
    begin
        sig_in_q <= 1'b0;
        sig_in_qq <= 1'b0;
    end

    else
    begin
        sig_in_q <= sig_in;
        sig_in_qq <= sig_in_q;
    end

endmodule
