import { useState } from "react";
import { useNavigate, useParams } from "react-router";
import { X, Minus, Plus } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame"; // Ajustado según tu log
import { PRODUCTOS_DATA, DATA_GLOBAL } from "../../data/tiendasData"; 
import { useCart } from "../../context/CartContext"; // <--- ESTE ES EL CAMBIO CLAVE

export default function ProductoDetalle() {
  const { tiendaId, prodId, categoriaId } = useParams();
  const navigate = useNavigate();
  const [cantidad, setCantidad] = useState(1);
  const { agregarAlCarrito } = useCart();

  const categoriaData = DATA_GLOBAL[categoriaId || ""];
  const tienda = categoriaData?.tiendas.find((t: any) => t.id === tiendaId);
  const listaProductos = PRODUCTOS_DATA[tiendaId || ""] || [];
  const producto = listaProductos.find((p: any) => String(p.id) === String(prodId));

  if (!producto) {
    return (
      <IPhoneFrame>
        <div className="flex flex-col items-center justify-center h-full">
          <p className="text-gray-400 font-black">PRODUCTO NO ENCONTRADO</p>
          <button onClick={() => navigate(-1)} className="mt-4 text-[#FF441F] font-bold">Volver</button>
        </div>
      </IPhoneFrame>
    );
  }

  const onAgregarClick = () => {
    agregarAlCarrito(
      { ...producto, cantidad }, 
      tiendaId || "", 
      tienda?.nombre || "Tienda"
    );
    navigate(-1);
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        <div className="absolute top-12 left-6 z-20">
          <button 
            onClick={() => navigate(-1)}
            className="p-2 bg-white/90 backdrop-blur-md rounded-full shadow-lg active:scale-90 transition-transform"
          >
            <X className="w-5 h-5 text-gray-900" />
          </button>
        </div>

        <div className="h-72 w-full">
          <img src={producto.img} className="w-full h-full object-cover" alt={producto.nombre} />
        </div>

        <div className="flex-1 px-6 pt-8">
          <span className="text-2xl font-black text-[#FF441F]">${producto.precio}</span>
          <h1 className="text-3xl font-black text-gray-900 mt-1 uppercase leading-tight">{producto.nombre}</h1>
          <div className="mt-6">
            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest mb-2">Detalles</h3>
            <p className="text-gray-600 font-medium leading-relaxed">{producto.info}</p>
          </div>
        </div>

        <div className="p-6 bg-white border-t border-gray-100">
          <div className="flex items-center gap-4">
            <div className="flex items-center justify-between bg-white border-2 border-gray-100 rounded-2xl p-1 min-w-[120px]">
              <button onClick={() => setCantidad(Math.max(1, cantidad - 1))} className="p-2 text-gray-400">
                <Minus className="w-5 h-5" />
              </button>
              <span className="font-black text-lg text-gray-800">{cantidad}</span>
              <button onClick={() => setCantidad(cantidad + 1)} className="p-2 text-gray-400">
                <Plus className="w-5 h-5" />
              </button>
            </div>

            <button 
              onClick={onAgregarClick}
              className="flex-1 rounded-2xl py-3 px-4 flex flex-col items-center justify-center"
              style={{ backgroundColor: '#00BFA5' }}
            >
              <span className="text-white font-black text-sm uppercase">Agregar</span>
              <span className="text-white/90 font-bold text-xs">${(producto.precio * cantidad).toFixed(2)}</span>
            </button>
          </div>
        </div>
      </div>
    </IPhoneFrame>
  );
}