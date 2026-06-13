import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Shield, GraduationCap, UserSquare, UserPlus, FileSignature } from 'lucide-react';
import Navbar from '../components/Navbar';

export default function Index() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-white flex flex-col">
      <Navbar />

      <main className="flex-1 flex flex-col items-center justify-center px-6 py-12 text-center max-w-4xl mx-auto">
        {/* Hero Badge */}
        <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-tomato-50 text-tomato-600 font-semibold text-xs mb-6 border border-tomato-100">
          <Shield size={14} />
          <span>Real-time AI-Proctored Exam Platform</span>
        </div>

        {/* Hero Heading */}
        <h1 className="text-4xl md:text-5xl font-bold text-dark-900 tracking-tight leading-tight mb-4">
          Conduct Secure, Honest, and <br />
          <span className="text-tomato-500">Smart Online Exams</span>
        </h1>
        
        <p className="text-gray-500 max-w-xl text-base md:text-lg mb-12 leading-relaxed">
          A premium exam-taking application integrated with advanced proctoring logs. Monitors copy-paste actions, webcam feeds, and demerit blocks to maintain academic integrity.
        </p>

        {/* Login Portals Grid */}
        <div className="w-full grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
          {/* Student Login Card */}
          <div 
            onClick={() => navigate('/login/student')}
            className="group card-hover p-6 cursor-pointer flex flex-col items-center text-center hover:border-tomato-500"
          >
            <div className="w-14 h-14 rounded-2xl bg-tomato-50 text-tomato-500 flex items-center justify-center mb-4 group-hover:scale-110 smooth-transition">
              <UserSquare size={28} />
            </div>
            <h3 className="text-lg font-bold text-dark-900 mb-2">Student Portal</h3>
            <p className="text-xs text-gray-400 mb-4">Login with StudentID and attend scheduled exams.</p>
            <button className="text-xs font-semibold text-tomato-600 group-hover:text-tomato-700 inline-flex items-center gap-1">
              Enter Student ID &rarr;
            </button>
          </div>

          {/* Teacher Login Card */}
          <div 
            onClick={() => navigate('/login/teacher')}
            className="group card-hover p-6 cursor-pointer flex flex-col items-center text-center hover:border-tomato-500"
          >
            <div className="w-14 h-14 rounded-2xl bg-tomato-50 text-tomato-500 flex items-center justify-center mb-4 group-hover:scale-110 smooth-transition">
              <GraduationCap size={28} />
            </div>
            <h3 className="text-lg font-bold text-dark-900 mb-2">Teacher Console</h3>
            <p className="text-xs text-gray-400 mb-4">Manage courses, set exam questions, and view live logs.</p>
            <button className="text-xs font-semibold text-tomato-600 group-hover:text-tomato-700 inline-flex items-center gap-1">
              Teacher Login &rarr;
            </button>
          </div>

          {/* Admin Login Card */}
          <div 
            onClick={() => navigate('/login/admin')}
            className="group card-hover p-6 cursor-pointer flex flex-col items-center text-center hover:border-tomato-500"
          >
            <div className="w-14 h-14 rounded-2xl bg-tomato-50 text-tomato-500 flex items-center justify-center mb-4 group-hover:scale-110 smooth-transition">
              <Shield size={28} />
            </div>
            <h3 className="text-lg font-bold text-dark-900 mb-2">Admin Panel</h3>
            <p className="text-xs text-gray-400 mb-4">Control credentials, approve teachers, and assign courses.</p>
            <button className="text-xs font-semibold text-tomato-600 group-hover:text-tomato-700 inline-flex items-center gap-1">
              System Admin &rarr;
            </button>
          </div>
        </div>

        {/* Separator / Subtext */}
        <div className="relative flex py-5 items-center w-full max-w-md mb-8">
          <div className="flex-grow border-t border-gray-150"></div>
          <span className="flex-shrink mx-4 text-xs font-semibold text-gray-400 uppercase tracking-widest">Don't have an account?</span>
          <div className="flex-grow border-t border-gray-150"></div>
        </div>

        {/* Registration Options */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center w-full max-w-md">
          <button 
            onClick={() => navigate('/register/student')}
            className="tomato-btn sm:flex-1 py-3"
          >
            <UserPlus size={18} />
            <span>Register as Student</span>
          </button>
          <button 
            onClick={() => navigate('/register/teacher')}
            className="tomato-btn-outline sm:flex-1 py-3"
          >
            <FileSignature size={18} />
            <span>Register as Teacher</span>
          </button>
        </div>
      </main>

      <footer className="py-6 border-t border-gray-100 text-center text-xs text-gray-400">
        &copy; {new Date().getFullYear()} SafeExam.AI. All rights reserved. Powered by YOLOv8 Proctoring System.
      </footer>
    </div>
  );
}
