function SQNR = SQNR( sig,quant_sig )
SQNR = sum(sum(sig.^2))/sum(sum((sig-quant_sig).^2));
SQNR = 10*log10(SQNR);
end

