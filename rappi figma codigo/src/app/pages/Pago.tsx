import { useState } from "react";
import { useNavigate } from "react-router"; // Quitamos useLocation porque usaremos el Contexto
import { ArrowLeft, Info, Circle, CheckCircle2, CreditCard, Banknote, X, Plus } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";
import { useCart } from "../../context/CartContext"; // Importamos el hook

export default function Pago() {
  const navigate = useNavigate();
  const { items, totalPrecio, nombreTienda } = useCart(); // Traemos la info real del carrito
  
  // ESTADOS
  const [metodoEntrega, setMetodoEntrega] = useState("mas-rapido");
  const [showModal, setShowModal] = useState(false);
  const [view, setView] = useState<"seleccion" | "formulario">("seleccion");
  const [metodoPago, setMetodoPago] = useState({ tipo: "Efectivo", detalle: "Paga al recibir" });
  const [nuevaTarjeta, setNuevaTarjeta] = useState({ numero: "", fecha: "", cvv: "" });

  const costoEnvioBase = 29.00;

  const opcionesEntrega = [
    { id: "mas-rapido", titulo: "Más rápido", tiempo: "14-34 min", extra: 26.99 },
    { id: "estandar", titulo: "Estándar", tiempo: "28-48 min", extra: 0.00 },
    { id: "ahorra", titulo: "Ahorra", tiempo: "43-63 min", extra: -9.90 },
  ];

  const extraEntrega = opcionesEntrega.find(o => o.id === metodoEntrega)?.extra || 0;
  
  // Cálculo final basado en el total del carrito + envío + opción de velocidad
  const totalFinal = (totalPrecio || 0) + costoEnvioBase + extraEntrega;

  const guardarTarjeta = () => {
    if (nuevaTarjeta.numero.length > 10) {
      setMetodoPago({ tipo: "Tarjeta", detalle: `**** ${nuevaTarjeta.numero.slice(-4)}` });
      setShowModal(false);
      setView("seleccion");
    }
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        
        {/* Header */}
        <div className="px-6 pt-12 pb-4 flex items-center gap-4 border-b border-gray-50">
          <button onClick={() => navigate(-1)} className="p-1 active:scale-90 transition-transform">
            <ArrowLeft className="w-6 h-6 text-gray-900" />
          </button>
          <h1 className="text-xl font-black text-gray-900 italic uppercase tracking-tighter">Finalizar Pedido</h1>
        </div>

        <div className="flex-1 overflow-y-auto px-6 py-6 pb-40 scrollbar-hide">
          {/* Dirección */}
          <div className="flex items-start gap-3 mb-8 bg-gray-50 p-4 rounded-2xl">
            <div>
              <h2 className="font-black text-gray-900 leading-tight uppercase text-xs">Casa</h2>
              <p className="text-[11px] font-bold text-gray-400 uppercase tracking-tighter">Av. De la Raza 1234, Ciudad Juárez</p>
            </div>
          </div>

          {/* Entrega Estimada */}
          <div className="mb-8">
            <div className="flex items-center gap-2 mb-4">
              <h3 className="font-black text-gray-900 uppercase text-[10px] tracking-widest">Entrega estimada</h3>
              <Info className="w-3 h-3 text-gray-300" />
            </div>
            <div className="space-y-3">
              {opcionesEntrega.map((op) => (
                <button 
                  key={op.id} 
                  onClick={() => setMetodoEntrega(op.id)} 
                  className={`w-full flex items-center justify-between p-4 rounded-2xl border-2 transition-all ${metodoEntrega === op.id ? "border-[#FF441F] bg-[#FF441F]/5" : "border-gray-100"}`}
                >
                  <div className="flex items-center gap-4">
                    {metodoEntrega === op.id ? <CheckCircle2 className="w-5 h-5 text-[#FF441F]" /> : <Circle className="w-5 h-5 text-gray-200" />}
                    <div className="text-left">
                      <p className="font-black text-gray-900 text-sm">{op.titulo}</p>
                      <p className="text-[10px] font-bold text-gray-400 uppercase">{op.tiempo}</p>
                    </div>
                  </div>
                  <span className={`font-black text-xs ${op.extra < 0 ? "text-green-500" : "text-gray-900"}`}>
                    {op.extra === 0 ? "Gratis" : (op.extra > 0 ? `+$${op.extra.toFixed(2)}` : `-$${Math.abs(op.extra).toFixed(2)}`)}
                  </span>
                </button>
              ))}
            </div>
          </div>

          {/* Método de Pago */}
          <div className="mb-8">
            <div className="flex justify-between items-center mb-4">
              <h3 className="font-black text-gray-900 uppercase text-[10px] tracking-widest">Método de pago</h3>
              <button onClick={() => setShowModal(true)} className="text-[10px] font-black text-[#00BFA5] bg-[#00BFA5]/10 px-3 py-1 rounded-full uppercase">Cambiar</button>
            </div>
            <div className="flex items-center gap-4 p-4 bg-gray-50 rounded-2xl border border-gray-100">
              <div className="w-10 h-10 rounded-xl bg-[#00BFA5] flex items-center justify-center text-white shadow-lg shadow-teal-500/20">
                {metodoPago.tipo === "Efectivo" ? <Banknote className="w-5 h-5" /> : <CreditCard className="w-5 h-5" />}
              </div>
              <div className="flex flex-col">
                <span className="font-black text-gray-800 text-sm">{metodoPago.tipo}</span>
                <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest">{metodoPago.detalle}</span>
              </div>
            </div>
          </div>

          <hr className="border-gray-100 mb-8" />

          {/* Resumen DINÁMICO */}
          <div>
            <div className="flex justify-between items-center mb-4">
                <h3 className="font-black text-gray-900 uppercase text-[10px] tracking-widest">Resumen de tu pedido</h3>
                <span className="text-[10px] font-black text-gray-400">{items.length} productos</span>
            </div>
            
            <div className="space-y-4">
              {items.map((item: any) => (
                <div key={item.id} className="flex items-center gap-4 bg-gray-50/50 p-2 rounded-xl">
                  <img src={item.img} className="w-12 h-12 rounded-lg object-cover border border-gray-100" alt={item.nombre} />
                  <div className="flex-1">
                    <h4 className="font-black text-gray-900 text-[11px] uppercase leading-tight line-clamp-1">{item.nombre}</h4>
                    <p className="text-[#FF441F] font-black text-xs">${item.precio.toFixed(2)} x {item.cantidad}</p>
                  </div>
                  <span className="font-black text-gray-900 text-xs">${(item.precio * item.cantidad).toFixed(2)}</span>
                </div>
              ))}
            </div>

            {/* Desglose de costos */}
            <div className="mt-6 space-y-2 border-t border-dashed border-gray-200 pt-4">
                <div className="flex justify-between text-[11px] font-bold text-gray-400 uppercase tracking-widest">
                    <span>Subtotal</span>
                    <span>${totalPrecio.toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-[11px] font-bold text-gray-400 uppercase tracking-widest">
                    <span>Costo de envío</span>
                    <span>${costoEnvioBase.toFixed(2)}</span>
                </div>
                {extraEntrega !== 0 && (
                    <div className="flex justify-between text-[11px] font-bold text-gray-400 uppercase tracking-widest">
                        <span>Ajuste de entrega</span>
                        <span className={extraEntrega < 0 ? "text-green-500" : "text-gray-900"}>
                            {extraEntrega > 0 ? `+$${extraEntrega.toFixed(2)}` : `-$${Math.abs(extraEntrega).toFixed(2)}`}
                        </span>
                    </div>
                )}
            </div>
          </div>
        </div>

        {/* Footer de Pago */}
        <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-100 px-8 py-6 pb-10 flex justify-between items-center z-40 rounded-t-[2.5rem] shadow-[0_-15px_40px_rgba(0,0,0,0.08)]">
          <div className="flex flex-col">
            <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Total Final</span>
            <span className="text-2xl font-black text-gray-900 italic">${totalFinal.toFixed(2)}</span>
          </div>
          <button 
            onClick={() => navigate('/Pro-pedi', { 
              state: { 
                metodoPago: metodoPago, 
                entrega: opcionesEntrega.find(o => o.id === metodoEntrega)?.titulo 
              } 
            })} 
            className="px-8 py-4 rounded-2xl text-white font-black text-xs uppercase tracking-widest active:scale-95 transition-all bg-[#00BFA5] shadow-lg shadow-teal-500/30"
          >
            Continuar
          </button>
        </div>

        {/* MODAL DE PAGO (Sin cambios, funciona perfecto) */}
        {showModal && (
          <div className="absolute inset-0 bg-black/60 z-[60] flex items-end animate-in fade-in duration-300">
            <div className="w-full bg-white rounded-t-[3rem] p-8 pb-12 animate-in slide-in-from-bottom duration-300">
              <div className="flex justify-between items-center mb-6">
                <h3 className="text-xl font-black text-gray-900 italic uppercase">
                  {view === "seleccion" ? "Método de pago" : "Nueva Tarjeta"}
                </h3>
                <button onClick={() => {setShowModal(false); setView("seleccion")}} className="p-2 bg-gray-100 rounded-full active:scale-90 transition-transform">
                  <X className="w-4 h-4 text-gray-500" />
                </button>
              </div>

              {view === "seleccion" ? (
                <div className="space-y-4">
                  <button onClick={() => {setMetodoPago({ tipo: "Efectivo", detalle: "Paga al recibir" }); setShowModal(false)}} className="w-full flex items-center gap-4 p-5 rounded-[1.5rem] bg-gray-50 active:scale-95 transition-transform border border-gray-100">
                    <div className="p-3 bg-white rounded-xl shadow-sm text-[#00BFA5]"><Banknote /></div>
                    <span className="font-black text-gray-800 uppercase text-sm tracking-tighter">Efectivo al recibir</span>
                  </button>
                  <button onClick={() => setView("formulario")} className="w-full flex items-center gap-4 p-5 rounded-[1.5rem] bg-gray-50 active:scale-95 transition-transform border-2 border-dashed border-gray-200">
                    <div className="p-3 bg-white rounded-xl shadow-sm text-gray-400"><Plus /></div>
                    <span className="font-black text-gray-400 uppercase text-sm tracking-tighter">Agregar Tarjeta</span>
                  </button>
                </div>
              ) : (
                <div className="space-y-4">
                  <input type="text" placeholder="NÚMERO DE TARJETA" className="w-full p-4 bg-gray-50 rounded-xl border-none font-bold focus:ring-2 focus:ring-[#00BFA5] text-sm" onChange={(e) => setNuevaTarjeta({...nuevaTarjeta, numero: e.target.value})} />
                  <div className="flex gap-4">
                    <input type="text" placeholder="MM/AA" className="w-1/2 p-4 bg-gray-50 rounded-xl border-none font-bold text-sm" onChange={(e) => setNuevaTarjeta({...nuevaTarjeta, fecha: e.target.value})} />
                    <input type="text" placeholder="CVV" className="w-1/2 p-4 bg-gray-50 rounded-xl border-none font-bold text-sm" onChange={(e) => setNuevaTarjeta({...nuevaTarjeta, cvv: e.target.value})} />
                  </div>
                  <button onClick={guardarTarjeta} className="w-full py-5 bg-[#00BFA5] text-white font-black rounded-2xl uppercase tracking-widest mt-4 shadow-lg shadow-teal-500/20">Guardar y Usar</button>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
      <style>{`.scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </IPhoneFrame>
  );
}