import { useNavigate } from "react-router";
import { ArrowLeft, Trash2, Minus, Plus, ShoppingBag } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";
import { useCart } from "../../context/CartContext"; 

export default function Canasta() {
  const navigate = useNavigate();
  
  const { 
    items, 
    totalPrecio, 
    agregarAlCarrito, 
    nombreTienda,
    tiendaActualId // Extraemos el ID guardado
  } = useCart();

  const manejarCantidad = (producto: any, cambio: number) => {
    // Usamos SIEMPRE tiendaActualId y nombreTienda del contexto 
    // para evitar el error de "Ya tienes productos de otra tienda"
    agregarAlCarrito(
      { ...producto, cantidad: cambio }, 
      tiendaActualId, 
      nombreTienda
    );
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden">
        {/* HEADER */}
        <div className="px-6 pt-12 pb-4 flex items-center gap-4 border-b border-gray-50">
          <button onClick={() => navigate(-1)} className="p-1 active:scale-90 transition-transform">
            <ArrowLeft className="w-6 h-6 text-gray-900" />
          </button>
          <div className="flex flex-col">
            <h1 className="text-xl font-black text-gray-900 italic uppercase tracking-tighter">Mi Canasta</h1>
            {nombreTienda && <span className="text-[10px] font-bold text-[#00BFA5] uppercase tracking-widest">{nombreTienda}</span>}
          </div>
        </div>

        {/* LISTADO DE PRODUCTOS */}
        <div className="flex-1 overflow-y-auto px-6 py-4 scrollbar-hide">
          {items && items.length > 0 ? (
            items.map((item: any) => (
              <div key={item.id} className="flex items-center gap-4 py-6 border-b border-gray-100/50">
                <div className="w-16 h-16 rounded-2xl overflow-hidden bg-gray-50 border border-gray-100 shadow-sm">
                  <img 
                    src={item.img} 
                    className="w-full h-full object-cover" 
                    alt={item.nombre}
                  />
                </div>
                
                <div className="flex-1">
                  <h3 className="font-black text-gray-900 uppercase text-[11px] leading-tight mb-1">{item.nombre}</h3>
                  <p className="text-[#FF441F] font-black text-sm">${(item.precio || 0).toFixed(2)}</p>
                </div>

                <div className="flex items-center bg-gray-100 rounded-2xl p-1 gap-1">
                  <button 
                    onClick={() => manejarCantidad(item, -1)} 
                    className="p-2 text-gray-500 bg-white rounded-xl shadow-sm active:scale-90 transition-transform"
                  >
                    {item.cantidad <= 1 ? <Trash2 className="w-4 h-4 text-red-500" /> : <Minus className="w-4 h-4 text-gray-900" />}
                  </button>
                  
                  <span className="font-black text-gray-900 px-2 min-w-[24px] text-center text-sm">
                    {item.cantidad}
                  </span>
                  
                  <button 
                    onClick={() => manejarCantidad(item, 1)} 
                    className="p-2 bg-white rounded-xl shadow-sm text-gray-900 active:scale-90 transition-transform"
                  >
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))
          ) : (
            <div className="h-full flex flex-col items-center justify-center text-center px-10">
              <div className="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mb-4">
                <ShoppingBag className="w-8 h-8 text-gray-200" />
              </div>
              <p className="font-black uppercase tracking-tighter text-xl text-gray-300 italic">Canasta vacía</p>
              <button 
                onClick={() => navigate('/home')}
                className="mt-4 text-[#00BFA5] font-black uppercase text-[10px] tracking-widest border-b-2 border-[#00BFA5]"
              >
                Volver a la tienda
              </button>
            </div>
          )}
        </div>

        {/* FOOTER */}
        <div className="p-8 bg-white border-t border-gray-100">
          <div className="flex justify-between items-center">
            <div className="flex flex-col">
              <span className="text-gray-400 text-[10px] font-black uppercase tracking-widest leading-none mb-1">Total a pagar</span>
              <span className="text-3xl font-black text-gray-900 tracking-tighter italic">
                ${(totalPrecio || 0).toFixed(2)}
              </span>
            </div>
            
            <button 
              disabled={!items || items.length === 0}
              onClick={() => navigate('/pago')}
              className={`px-10 py-4 rounded-[1.5rem] text-white font-black text-sm uppercase tracking-widest shadow-lg transition-all active:scale-95 ${
                items && items.length > 0 ? "bg-[#00BFA5] shadow-teal-500/20" : "bg-gray-200 cursor-not-allowed text-gray-400 shadow-none"
              }`}
            >
              Continuar
            </button>
          </div>
        </div>
      </div>
      <style>{`.scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </IPhoneFrame>
  );
}