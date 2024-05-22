module vector_multiplier #(
    // Antall elementer per vektor
    parameter VECTOR_SIZE = 8,
    // Antall bits per element
    parameter ELEMENT_SIZE = 16
)(
    input clk,
    // Reset flagg
    input rst,
    // Start flagg
    input trigger,
    // Vektor 1 som et flat array
    input [ELEMENT_SIZE*VECTOR_SIZE-1:0] vector_a,
    // Vektor 1 som et flat array
    input [ELEMENT_SIZE*VECTOR_SIZE-1:0] vector_b,
    // Resultatvektor av elementvis multiplikasjon
    output reg [ELEMENT_SIZE*VECTOR_SIZE-1:0] result,
    // Prikkprodukt
    output reg [ELEMENT_SIZE-1:0] dot_product
);

// Kjøres for hver klokkesykel, kunne eventuelt brukt * istedenfor clk.
always @(posedge clk ) begin
    // Sjekker om reset-flagg er satt
    if (rst) begin
        result = 0;
        dot_product = 0;
    // Sjekker om flagg for å starte utregning er satt
    end else if (trigger) begin
        dot_product = 0;
        for (integer i = 0; i < VECTOR_SIZE; i = i + 1) begin
            // Her brukes blocking, neste statement må vente på denne.
            // Bruk av <= resulterer i at resultatet av multiplikasjonen ikke er satt før etter klokkesykelen.
            result[i*ELEMENT_SIZE +: ELEMENT_SIZE] = vector_a[i*ELEMENT_SIZE +: ELEMENT_SIZE] * vector_b[i*ELEMENT_SIZE +: ELEMENT_SIZE];
            // Her vil da prikkproduktet ikke oppdatere seg med resultatet av multiplikasjonen.
            // Blocking fikser dette.
            // Legger resultaet av multiplikasjon for ett element til prikkproduktet.
            dot_product = dot_product + result[i*ELEMENT_SIZE +: ELEMENT_SIZE];
        end
    end
end
endmodule

