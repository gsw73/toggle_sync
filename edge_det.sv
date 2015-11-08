module edge_det
(
    input logic clk,
    input logic rst_n,

    input logic sig,
    output logic edge_pulse
);

// =======================================================================
// Declarations & Parameters

logic rise_edge;
logic fall_edge;
logic sig_del;

// =======================================================================
// Combinational Logic

always_comb
    rise_edge = sig & ~sig_del;

always_comb
    fall_edge = ~sig & sig_del;

always_comb
    edge_pulse = rise_edge || fall_edge;

// =======================================================================
// Registered Logic

// Register:  sig_del

always_ff @( posedge clk )

    if ( !rst_n )
        sig_del <= 1'b0;

    else
        sig_del <= sig;

endmodule
