import { useNavigate } from "react-router";
import { ArrowLeft, UserPlus } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";

export default function SelectorCuentas() {
  const navigate = useNavigate();

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden">
        
        {/* Header con Logo de Google */}
        <div className="flex items-center justify-between px-4 pt-12 pb-4 border-b bg-white">
          <button 
            onClick={() => navigate('/')}
            className="p-2 hover:bg-gray-50 rounded-full transition-colors"
          >
            <ArrowLeft className="w-6 h-6 text-gray-700" />
          </button>
          
          <div className="flex-1 flex justify-center">
            {/* Logo de Google oficial */}
            <img 
              src="https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg" 
              alt="Google" 
              className="h-6 w-auto"
            />
          </div>
          <div className="w-10" /> 
        </div>

        {/* Cuerpo de la pantalla */}
        <div className="flex-1 px-6 py-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-1 tracking-tight">Elegir una cuenta</h1>
          <p className="text-gray-500 text-sm mb-10">
            para continuar con <span className="font-bold text-[#FF441F]">Rappi</span>
          </p>

          <div className="space-y-3">
            {/* Cuenta ya existente */}
            <button
              onClick={() => navigate('/setup-direccion')}
              className="w-full flex items-center gap-4 p-4 border border-gray-100 rounded-2xl bg-white shadow-sm hover:bg-gray-50 transition-all active:scale-[0.98]"
            >
              <div className="w-12 h-12 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold text-lg shadow-inner">
                J
              </div>
              <div className="flex flex-col text-left">
                <span className="font-bold text-gray-800">Juan Pérez</span>
                <span className="text-xs text-gray-500 font-medium">juan.perez@gmail.com</span>
              </div>
            </button>

            {/* Botón Agregar cuenta CORREGIDO (Sin línea azul ni cambios bruscos) */}
            <button
              onClick={() => navigate('/login-google')}
              className="w-full flex items-center gap-4 p-4 border border-gray-100 rounded-2xl bg-white transition-all active:scale-[0.98]"
            >
              <div className="w-12 h-12 rounded-full bg-gray-50 flex items-center justify-center border border-gray-100">
                <UserPlus className="w-5 h-5 text-gray-400" />
              </div>
              <span className="font-bold text-gray-700 text-sm">Usar otra cuenta</span>
            </button>
          </div>
        </div>

        {/* Footer Legal */}
        <div className="px-8 pb-10">
          <p className="text-[10px] text-gray-400 text-center leading-relaxed">
            Para continuar, Google compartirá tu nombre, dirección de correo electrónico,
            preferencia de idioma y foto de perfil con <span className="font-semibold">Rappi</span>. 
            Antes de usar esta app, puedes revisar su <span className="text-blue-500">política de privacidad</span>.
          </p>
        </div>

      </div>
    </IPhoneFrame>
  );
}