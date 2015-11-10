`include "toggle_flop.sv"
`include "edge_det.sv"
`include "sync_dff.sv"

module toggle_sync
(
    input logic clka,
    input logic rsta_n,

    input logic clkb,
    input logic rstb_n,

    input logic pulse_in,
    output logic pulse_out
);

// =======================================================================
// Declarations & Parameters

logic pola;
logic plb;

// =======================================================================
// Module Instantiations

toggle_flop u_toggle_flop
(
    .clk( clka ),
    .rst_n( rsta_n ),

    .sel( pulse_in ),
    .pol( pola )
);

sync_dff #( .WIDTH( 1 ) ) u_sync_dff
(
    .clk( clkb ),
    .rst_n( rstb_n ),

    .sig_in( pola ),
    .sig_out( polb )
);

edge_det u_edge_det
(
    .clk( clkb ),
    .rst_n( rstb_n ),

    .sig( polb ),
    .edge_pulse( pulse_out )
);
    
endmodule
