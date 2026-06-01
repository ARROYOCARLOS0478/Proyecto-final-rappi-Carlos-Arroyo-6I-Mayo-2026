import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { X, ChevronDown, ChevronUp, MapPin, Package, Utensils, Bike, CheckCircle2, Star, CreditCard } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";

export default function DetalleEntrega() {
  const navigate = useNavigate();
  const [showResumen, setShowResumen] = useState(false);

  const [pedido, setPedido] = useState(() => {
    const guardado = localStorage.getItem("flash_pedido_activo");
    return guardado ? JSON.parse(guardado) : null;
  });

  const etapas = [
    { titulo: "Alistando", icon: <Package className="w-5 h-5" /> },
    { titulo: "Preparando", icon: <Utensils className="w-5 h-5" /> },
    { titulo: "En camino", icon: <Bike className="w-5 h-5" /> },
    { titulo: "Entregado", icon: <CheckCircle2 className="w-5 h-5" /> }
  ];

  // MOTOR DE PROGRESO SINCRONIZADO
  useEffect(() => {
    if (pedido && pedido.etapa < 3) {
      const interval = setInterval(() => {
        setPedido((prev: any) => {
          if (!prev) return null;
          let nuevoProgreso = (prev.progresoInterno || 0) + 1;
          let nuevaEtapa = prev.etapa;
          if (nuevoProgreso >= 100) {
            nuevaEtapa = Math.min(prev.etapa + 1, 3);
            nuevoProgreso = 0;
          }
          const actualizado = { ...prev, etapa: nuevaEtapa, progresoInterno: nuevoProgreso };
          localStorage.setItem("flash_pedido_activo", JSON.stringify(actualizado));
          return actualizado;
        });
      }, 50);
      return () => clearInterval(interval);
    }
  }, [pedido?.etapa]);

  if (!pedido) return null;

  const esFinalizado = pedido.etapa === 3;
  const anchoBarra = (pedido.etapa * 33.33) + ((pedido.progresoInterno || 0) / 3);

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        
        {/* HEADER */}
        <div className="absolute top-12 left-0 right-0 px-6 z-50 flex items-center gap-3">
          <button onClick={() => navigate("/home")} className="p-2 bg-white rounded-full shadow-md border border-gray-200 active:scale-90 transition-transform">
            <X className="w-6 h-6 text-gray-900" />
          </button>
          {esFinalizado && (
            <span className="font-black text-lg text-gray-900 uppercase tracking-tighter animate-in fade-in">
              {pedido.tienda}
            </span>
          )}
        </div>

        <div className="flex-1 overflow-y-auto px-6 pt-28 pb-10 scrollbar-hide">
          {!esFinalizado ? (
            /* --- VISTA: PEDIDO EN CURSO --- */
            <div className="animate-in fade-in">
              <h1 className="text-2xl font-black text-gray-900 mb-1 uppercase tracking-tight">
                {etapas[pedido.etapa].titulo} tu pedido
              </h1>
              <p className="text-sm font-black text-[#00BFA5] mb-8 uppercase tracking-tighter">Sigue tu entrega en vivo</p>

              {/* BARRA DE PROGRESO */}
              <div className="mb-12 relative px-2">
                <div className="flex justify-between items-center relative z-10">
                  {etapas.map((item, index) => (
                    <div key={index} className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${pedido.etapa >= index ? "bg-[#E0F7F4] text-[#00BFA5]" : "bg-gray-100 text-gray-500"}`}>
                      {item.icon}
                    </div>
                  ))}
                </div>
                <div className="absolute top-5 left-8 right-8 h-1.5 bg-gray-100 -z-0 rounded-full overflow-hidden">
                  <div className="h-full bg-[#00BFA5] transition-all duration-300 ease-linear" style={{ width: `${anchoBarra}%` }} />
                </div>
              </div>

              {/* UBICACIÓN */}
              <div className="flex items-center gap-4 mb-8 px-2">
                <div className="p-3 bg-gray-50 rounded-2xl text-[#00BFA5]"><MapPin className="w-6 h-6" /></div>
                <div>
                  <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-0.5">Yo recibo en</h3>
                  <p className="text-sm font-black text-gray-900 uppercase tracking-tight">Av. De la Raza 1234</p>
                </div>
              </div>

              {/* RESUMEN DEL PEDIDO DINÁMICO */}
              <div className="bg-gray-100 rounded-[2rem] p-6 mb-8 transition-all">
                <button onClick={() => setShowResumen(!showResumen)} className="w-full flex justify-between items-center">
                  <div className="text-left">
                    <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">Resumen del pedido</h3>
                    {!showResumen && (
                      <p className="text-xs font-black text-gray-800 uppercase animate-in fade-in">
                        {pedido.totalProductos} Productos - ${pedido.monto?.toFixed(2)}
                      </p>
                    )}
                  </div>
                  {showResumen ? <ChevronUp className="text-gray-900" /> : <ChevronDown className="text-gray-900" />}
                </button>
                
                {showResumen && (
                  <div className="mt-6 space-y-3 animate-in slide-in-from-top-2">
                    {pedido.items?.map((item: any, i: number) => (
                      <div key={i} className="flex justify-between text-[11px] font-black uppercase text-gray-700">
                        <span>{item.cantidad}x {item.nombre}</span>
                        <span>${(item.precio * item.cantidad).toFixed(2)}</span>
                      </div>
                    ))}
                    <div className="h-[1px] bg-gray-200 my-2" />
                    <div className="flex justify-between items-center text-[11px] font-black uppercase">
                      <div className="flex items-center gap-2 text-gray-400">
                        <CreditCard className="w-3 h-3" />
                        <span>Método de pago</span>
                      </div>
                      <span className="text-gray-900">Efectivo</span>
                    </div>
                  </div>
                )}
              </div>

              {/* REPARTIDOR */}
              <div className="flex items-center gap-4 p-2 border-t border-gray-100 pt-6">
                <img src="https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100" className="w-14 h-14 rounded-2xl object-cover shadow-sm" />
                <div className="flex-1">
                  <h4 className="font-black text-gray-900 text-sm uppercase">Carlos Mendoza</h4>
                  <div className="flex items-center gap-2 mt-1">
                    <Star className="w-3 h-3 text-yellow-500 fill-yellow-500" />
                    <span className="text-[10px] font-black text-gray-900">4.9</span>
                  </div>
                  <span className="text-gray-400 block text-[9px] font-black uppercase tracking-tighter">1,240 Pedidos entregados</span>
                </div>
              </div>
            </div>
          ) : (
            /* --- VISTA: PEDIDO ENTREGADO --- */
            <div className="animate-in slide-in-from-bottom-6 duration-500">
              <p className="text-sm font-black text-[#00BFA5] mb-6 uppercase tracking-widest">Pedido entregado</p>
              
              <div className="flex items-center gap-4 mb-10">
                <img src="https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100" className="w-14 h-14 rounded-2xl object-cover shadow-sm" />
                <div className="flex-1">
                  <h4 className="font-black text-gray-900 text-base uppercase leading-none">Carlos Mendoza</h4>
                  <div className="flex items-center gap-3 mt-1 text-[10px] font-black uppercase">
                    <div className="flex items-center gap-1 text-gray-900">
                      <Star className="w-3 h-3 text-yellow-500 fill-yellow-500" />
                      <span>4.9</span>
                    </div>
                    <span className="text-gray-400">1,240 Pedidos entregados</span>
                  </div>
                </div>
              </div>

              {/* RESUMEN FINAL COLAPSABLE */}
              <div className="mb-10 border-b border-gray-100 pb-6">
                <button onClick={() => setShowResumen(!showResumen)} className="w-full flex justify-between items-end">
                  <div className="text-left">
                    <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">Total</h3>
                    <p className="text-3xl font-black text-gray-900 leading-none">
                      {`Productos - ${pedido.monto?.toFixed(2)}`}
                    </p>
                  </div>
                  <ChevronDown className={`w-6 h-6 text-gray-900 transition-transform ${showResumen ? "rotate-180" : ""}`} />
                </button>
                
                {showResumen && (
                  <div className="mt-6 space-y-3 animate-in fade-in">
                    {pedido.items?.map((item: any, i: number) => (
                      <div key={i} className="flex justify-between text-[11px] font-black uppercase text-gray-600">
                        <span>{item.cantidad}x {item.nombre}</span>
                        <span>${(item.precio * item.cantidad).toFixed(2)}</span>
                      </div>
                    ))}
                    <div className="flex justify-between text-[11px] font-black uppercase text-gray-400 pt-2 border-t border-gray-50">
                      <span>Método de pago</span>
                      <span>Efectivo</span>
                    </div>
                  </div>
                )}
              </div>

              {/* CONTENEDOR DE HISTORIAL MEJORADO */}
              <div className="bg-gray-50 rounded-[2.5rem] p-8 mb-8">
                <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-8">Cronología del pedido</h3>
                <div className="space-y-8 relative">
                  <div className="absolute left-[11px] top-2 bottom-2 w-[1.5px] bg-gray-200" />
                  
                  {/* Punto 1: Recepción */}
                  <div className="flex gap-5 relative z-10">
                    <div className="w-6 h-6 rounded-full bg-white border-2 border-[#00BFA5] flex items-center justify-center">
                       <div className="w-1.5 h-1.5 bg-[#00BFA5] rounded-full" />
                    </div>
                    <div>
                      <p className="text-[11px] font-black text-gray-900 uppercase">Pedido recibido</p>
                      <p className="text-[9px] font-bold text-gray-400 uppercase tracking-widest">12:30 pm</p>
                    </div>
                  </div>

                  {/* Punto 2: Preparación */}
                  <div className="flex gap-5 relative z-10">
                    <div className="w-6 h-6 rounded-full bg-white border-2 border-[#00BFA5] flex items-center justify-center">
                       <div className="w-1.5 h-1.5 bg-[#00BFA5] rounded-full" />
                    </div>
                    <div>
                      <p className="text-[11px] font-black text-gray-900 uppercase">Comida preparada</p>
                      <p className="text-[9px] font-bold text-gray-400 uppercase tracking-widest">12:45 pm</p>
                    </div>
                  </div>

                  {/* Punto 3: Repartidor asignado */}
                  <div className="flex gap-5 relative z-10">
                    <div className="w-6 h-6 rounded-full bg-white border-2 border-[#00BFA5] flex items-center justify-center">
                       <div className="w-1.5 h-1.5 bg-[#00BFA5] rounded-full" />
                    </div>
                    <div>
                      <p className="text-[11px] font-black text-gray-900 uppercase">Carlos recogió tu pedido</p>
                      <p className="text-[9px] font-bold text-gray-400 uppercase tracking-widest">12:55 pm</p>
                    </div>
                  </div>

                  {/* Punto 4: Llegada */}
                  <div className="flex gap-5 relative z-10">
                    <div className="w-6 h-6 rounded-full bg-white border-2 border-[#00BFA5] flex items-center justify-center">
                       <div className="w-1.5 h-1.5 bg-[#00BFA5] rounded-full" />
                    </div>
                    <div>
                      <p className="text-[11px] font-black text-gray-900 uppercase">Llegó a tu dirección</p>
                      <p className="text-[9px] font-bold text-gray-400 uppercase tracking-widest">01:10 pm</p>
                    </div>
                  </div>

                  {/* Punto 5: Entrega */}
                  <div className="flex gap-5 relative z-10">
                    <div className="w-6 h-6 rounded-full bg-[#00BFA5] flex items-center justify-center shadow-lg shadow-teal-100">
                       <CheckCircle2 className="w-3 h-3 text-white" strokeWidth={3} />
                    </div>
                    <div>
                      <p className="text-[11px] font-black text-[#00BFA5] uppercase">Entregado</p>
                      <p className="text-[9px] font-bold text-gray-400 uppercase tracking-widest">01:15 pm</p>
                    </div>
                  </div>
                </div>
              </div>

              <button 
                onClick={() => { localStorage.removeItem("flash_pedido_activo"); navigate('/home'); }} 
                className="w-full py-5 bg-[#00BFA5] text-white font-black rounded-3xl uppercase tracking-widest shadow-xl shadow-teal-50/50 active:scale-95 transition-all"
              >
                Cerrar
              </button>
            </div>
          )}
        </div>
      </div>
      <style>{`.scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </IPhoneFrame>
  );
}