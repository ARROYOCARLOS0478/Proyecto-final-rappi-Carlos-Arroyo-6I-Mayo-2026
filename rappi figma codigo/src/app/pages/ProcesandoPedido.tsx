import { useState, useEffect, useRef } from "react";
import { useNavigate, useLocation } from "react-router";
import { MapPin, Clock, Banknote, CreditCard, Check } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";
import { useCart } from "../../context/CartContext"; 

export default function ProcesandoPedido() {
  const navigate = useNavigate();
  const location = useLocation();
  const { items, totalPrecio, nombreTienda, limpiarCarrito } = useCart();
  
  const [paso, setPaso] = useState(1); 
  const [progreso, setProgreso] = useState(100);
  const carritoLimpiado = useRef(false);

  const state = location.state || {};
  const metodoPago = state.metodoPago || { tipo: "Efectivo" };
  const entrega = state.entrega || "Estándar";

  useEffect(() => {
    if (paso === 1) {
      const timerProgreso = setInterval(() => {
        setProgreso((prev) => (prev > 0 ? prev - 1.43 : 0));
      }, 100);

      const timerPaso2 = setTimeout(() => {
        setPaso(2);
      }, 7000);

      return () => {
        clearInterval(timerProgreso);
        clearTimeout(timerPaso2);
      };
    } else if (paso === 2) {
      // Creamos el objeto del pedido
      const pedidoParaEnviar = {
        tienda: nombreTienda,
        status: "Preparando",
        monto: totalPrecio,
        metodo: metodoPago.tipo,
        items: [...items],
        cantidadTotal: items.reduce((acc: number, item: any) => acc + item.cantidad, 0),
        etapa: 0, // Empezamos en la etapa 0
        timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
      };

      if (!carritoLimpiado.current) {
        // GUARDAMOS EN MEMORIA PARA QUE EL HOME LO VEA
        localStorage.setItem("flash_pedido_activo", JSON.stringify(pedidoParaEnviar));
        
        limpiarCarrito();
        carritoLimpiado.current = true;
      }

      const timerFinal = setTimeout(() => {
        // Enviamos el estado por si acaso, pero el Home ya lo tendrá en LocalStorage
        navigate("/Deta-entre", { 
          state: { pedidoActivo: pedidoParaEnviar } 
        });
      }, 7000);

      return () => clearTimeout(timerFinal);
    }
  }, [paso]); 

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        {paso === 1 ? (
          <div className="flex flex-col h-full px-8 pt-16">
            <h1 className="text-3xl font-black text-gray-900 leading-tight mb-2">
              Estamos creando tu pedido
            </h1>
            <h2 className="text-lg font-bold text-[#00BFA5] mb-1 uppercase tracking-tighter">
              {nombreTienda || "Tu Pedido"}
            </h2>
            <p className="text-sm font-black text-gray-900 mb-8 uppercase tracking-tighter">
              {items.length} producto{items.length !== 1 ? 's' : ''}
            </p>

            <div className="space-y-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-gray-50 rounded-full text-gray-400">
                  <MapPin className="w-5 h-5" />
                </div>
                <div>
                  <p className="text-sm font-black text-gray-900">Entrega en Casa</p>
                  <p className="text-xs font-bold text-gray-400">Av. De la Raza 1234</p>
                </div>
              </div>
              <div className="h-[1px] bg-gray-100 w-full" />
              <div className="flex items-center gap-4">
                <div className="p-3 bg-gray-50 rounded-full text-gray-400">
                  <Clock className="w-5 h-5" />
                </div>
                <div>
                  <p className="text-sm font-black text-gray-900">Llegada estimada</p>
                  <p className="text-xs font-bold text-gray-400 uppercase">{entrega}</p>
                </div>
              </div>
              <div className="h-[1px] bg-gray-100 w-full" />
              <div className="flex items-center gap-4">
                <div className="p-3 bg-gray-50 rounded-full text-gray-400">
                  {metodoPago.tipo === "Efectivo" ? <Banknote className="w-5 h-5" /> : <CreditCard className="w-5 h-5" />}
                </div>
                <div>
                  <p className="text-sm font-black text-gray-900">Método de Pago</p>
                  <p className="text-xs font-bold text-gray-400 uppercase">{metodoPago.tipo}</p>
                </div>
              </div>
            </div>

            <div className="mt-auto mb-12 relative">
              <button 
                onClick={() => navigate("/canasta")}
                className="w-full py-4 bg-[#00BFA5] text-white font-black rounded-2xl uppercase tracking-widest relative overflow-hidden active:scale-95 transition-transform"
              >
                <span className="relative z-10">Deshacer pedido</span>
                <div 
                  className="absolute bottom-0 left-0 h-1 bg-black/20 transition-all duration-100" 
                  style={{ width: `${progreso}%` }}
                />
              </button>
            </div>
          </div>
        ) : (
          <div className="flex flex-col h-full bg-[#E0F7F4] px-8 pt-16 items-start animate-in fade-in duration-500">
            <div className="w-14 h-14 bg-white rounded-full flex items-center justify-center mb-10 shadow-md">
              <Check className="w-8 h-8 text-[#00BFA5]" strokeWidth={4} />
            </div>
            <h1 className="text-3xl font-black text-[#00BFA5] leading-tight">
              Tu pedido fue creado con exito
            </h1>
            <div className="mt-10 w-full aspect-square flex items-center justify-center">
               <div className="w-32 h-32 bg-[#00BFA5]/10 rounded-full animate-ping" />
            </div>
          </div>
        )}
      </div>
    </IPhoneFrame>
  );
}