import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { 
  BookOpen, Plus, Calendar, Clock, FileQuestion, Trash2, Check,
  Camera, AlertCircle, RefreshCw, Download, Trash, Award,
  Menu, LogOut
} from 'lucide-react';
import Modal from '../components/Modal';

export default function TeacherDashboard() {
  const navigate = useNavigate();
  const token = localStorage.getItem('token');
  const [activeTab, setActiveTab] = useState('logs');
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);

  // Data State
  const [courses, setCourses] = useState([]);
  const [exams, setExams] = useState([]);
  const [proctoringLogs, setProctoringLogs] = useState([]);
  const [pendingEnrollments, setPendingEnrollments] = useState([]);
  const [rawLogs, setRawLogs] = useState('');
  const [profile, setProfile] = useState({ name: '', email: '', profile_image: '', joining_date: '' });

  // Question Management State
  const [selectedExamId, setSelectedExamId] = useState('');
  const [questions, setQuestions] = useState([]);

  // UI State
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  // Modals
  const [isExamModalOpen, setIsExamModalOpen] = useState(false);
  const [isQuestionModalOpen, setIsQuestionModalOpen] = useState(false);
  const [isEnrollModalOpen, setIsEnrollModalOpen] = useState(false);

  // Form Fields
  const [examForm, setExamForm] = useState({ course_id: '', title: '', exam_date: '', duration_minutes: '' });
  const [questionForm, setQuestionForm] = useState({ question_text: '', option_a: '', option_b: '', option_c: '', option_d: '', correct_option: 'A' });
  const [enrollForm, setEnrollForm] = useState({ courseId: '', studentId: '' });
  const [profileImageFile, setProfileImageFile] = useState(null);
  const [profileName, setProfileName] = useState('');

  const api = axios.create({
    headers: { Authorization: `Bearer ${token}` }
  });

  useEffect(() => {
    if (!token) {
      navigate('/login/teacher');
      return;
    }
    fetchData();
    // Poll proctoring logs and raw log files every 4 seconds to simulate "real-time" alerts
    const timer = setInterval(() => {
      fetchProctoringData();
    }, 4000);
    return () => clearInterval(timer);
  }, [token]);

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const [cRes, eRes, pRes] = await Promise.all([
        api.get('http://localhost:5000/api/teacher/courses'),
        api.get('http://localhost:5000/api/teacher/exams'),
        api.get('http://localhost:5000/api/teacher/profile')
      ]);

      setCourses(cRes.data);
      setExams(eRes.data);
      setProfile(pRes.data);
      setProfileName(pRes.data.name);

      await fetchProctoringData();
    } catch (err) {
      console.error(err);
      if (err.response?.status === 401 || err.response?.status === 403) {
        localStorage.clear();
        navigate('/login/teacher');
      } else {
        setError('Failed to fetch dashboard data.');
      }
    } finally {
      setLoading(false);
    }
  };

  const fetchProctoringData = async () => {
    try {
      const [lRes, rRes, peRes] = await Promise.all([
        api.get('http://localhost:5000/api/teacher/proctoring-logs'),
        api.get('http://localhost:5000/api/proctor/raw-logs'),
        api.get('http://localhost:5000/api/teacher/enrollments/pending')
      ]);
      setProctoringLogs(lRes.data);
      setRawLogs(rRes.data.logs);
      setPendingEnrollments(peRes.data);
    } catch (err) {
      console.error('Error fetching real-time proctor logs:', err);
    }
  };

  const triggerSuccess = (msg) => {
    setSuccess(msg);
    setTimeout(() => setSuccess(''), 4000);
  };

  // --- Profile Upload Action ---
  const handleProfileSubmit = async (e) => {
    e.preventDefault();
    setError('');
    const formData = new FormData();
    formData.append('name', profileName);
    if (profileImageFile) {
      formData.append('profile_image', profileImageFile);
    }

    try {
      const res = await api.put('http://localhost:5000/api/teacher/profile', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      triggerSuccess('Profile updated successfully');
      setProfile(res.data.user);
      localStorage.setItem('user', JSON.stringify(res.data.user));
    } catch (err) {
      setError('Error updating profile picture or details.');
    }
  };

  // --- Exam Actions ---
  const handleCreateExam = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/teacher/exams', examForm);
      setIsExamModalOpen(false);
      setExamForm({ course_id: '', title: '', exam_date: '', duration_minutes: '' });
      triggerSuccess('Exam scheduled successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error creating exam');
    }
  };

  const handleDeleteExam = async (id) => {
    if (!window.confirm('Delete this exam? This will wipe all its questions and grades.')) return;
    try {
      await api.delete(`http://localhost:5000/api/teacher/exams/${id}`);
      triggerSuccess('Exam deleted');
      fetchData();
      if (selectedExamId === id) {
        setQuestions([]);
        setSelectedExamId('');
      }
    } catch (err) {
      setError('Error deleting exam');
    }
  };

  // --- Question Actions ---
  const fetchQuestions = async (examId) => {
    setSelectedExamId(examId);
    try {
      const res = await api.get(`http://localhost:5000/api/teacher/exams/${examId}/questions`);
      setQuestions(res.data);
    } catch (err) {
      setError('Error fetching questions');
    }
  };

  const handleAddQuestion = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/teacher/questions', {
        ...questionForm,
        exam_id: selectedExamId
      });
      setIsQuestionModalOpen(false);
      setQuestionForm({ question_text: '', option_a: '', option_b: '', option_c: '', option_d: '', correct_option: 'A' });
      triggerSuccess('Question added');
      fetchQuestions(selectedExamId);
      fetchData(); // Reload counts
    } catch (err) {
      setError(err.response?.data?.message || 'Error adding question');
    }
  };

  const handleDeleteQuestion = async (id) => {
    try {
      await api.delete(`http://localhost:5000/api/teacher/questions/${id}`);
      triggerSuccess('Question deleted');
      fetchQuestions(selectedExamId);
      fetchData();
    } catch (err) {
      setError('Error deleting question');
    }
  };

  // --- Student Enrollment Actions ---
  const handleDirectEnroll = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/teacher/courses/enroll-student', enrollForm);
      setIsEnrollModalOpen(false);
      setEnrollForm({ courseId: '', studentId: '' });
      triggerSuccess('Student enrolled successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error enrolling student');
    }
  };

  const handleApproveEnrollment = async (courseId, studentId) => {
    try {
      await api.post('http://localhost:5000/api/teacher/courses/approve-enrollment', { courseId, studentId });
      triggerSuccess('Enrollment approved');
      fetchData();
    } catch (err) {
      setError('Error approving student');
    }
  };

  // --- Raw Log Actions ---
  const handleClearLogs = async () => {
    if (!window.confirm('Wipe the physical cheating logs file? This cannot be undone.')) return;
    try {
      await api.delete('http://localhost:5000/api/proctor/raw-logs');
      triggerSuccess('Physical log file cleared');
      fetchProctoringData();
    } catch (err) {
      setError('Failed to clear logs');
    }
  };

  // Raw download file
  const downloadLogs = () => {
    const blob = new Blob([rawLogs], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', 'cheating_activity_report.log');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col lg:flex-row">
      {/* Mobile Header */}
      <div className="lg:hidden flex items-center justify-between bg-white border-b border-gray-150 p-4 sticky top-0 z-30 shadow-sm">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg bg-tomato-500 flex items-center justify-center text-white font-extrabold text-sm">
            <BookOpen size={16} />
          </div>
          <span className="font-extrabold text-md text-black">Teach<span className="text-tomato-500">Tech</span></span>
        </div>
        <button
          onClick={() => setIsSidebarOpen(!isSidebarOpen)}
          className="p-2 border border-gray-200 rounded-lg text-gray-500 hover:bg-gray-55 transition-colors"
        >
          <Menu size={20} />
        </button>
      </div>

      {/* Sidebar Navigation */}
      <div className={`fixed inset-y-0 left-0 bg-white border-r border-gray-150 w-64 z-40 transform transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static flex flex-col justify-between shrink-0 ${
        isSidebarOpen ? 'translate-x-0' : '-translate-x-full'
      }`}>
        {/* Logo and Menu Links */}
        <div>
          {/* Brand Logo Header */}
          <div className="p-6 border-b border-gray-150 hidden lg:flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-tomato-500 flex items-center justify-center text-white shadow-lg shadow-tomato-500/20">
              <BookOpen className="w-6 h-6" />
            </div>
            <div>
              <span className="font-extrabold text-lg tracking-tight text-black">
                Teach<span className="text-tomato-500">Tech</span>
              </span>
              <span className="text-[10px] text-gray-400 block font-semibold tracking-widest uppercase">Teacher Console</span>
            </div>
          </div>

          {/* Navigation Links */}
          <div className="p-4 space-y-1.5">
            {[
              { id: 'logs', label: 'AI Proctor Alerts Feed', icon: AlertCircle },
              { id: 'exams', label: 'Exams & Question Bank', icon: FileQuestion },
              { id: 'enrollments', label: 'Students & Enrollments', icon: BookOpen },
              { id: 'profile', label: 'Instructor Settings', icon: Camera }
            ].map(tab => (
              <button
                key={tab.id}
                onClick={() => {
                  setActiveTab(tab.id);
                  setError('');
                  setIsSidebarOpen(false);
                }}
                className={`w-full flex items-center gap-3 px-4 py-3 font-semibold text-sm rounded-xl transition-all ${
                  activeTab === tab.id 
                    ? 'bg-tomato-500 text-white shadow-lg shadow-tomato-500/20 animate-fade-in'
                    : 'text-gray-500 hover:text-dark-900 hover:bg-gray-100/60'
                }`}
              >
                <tab.icon size={18} />
                <span>{tab.label}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Sidebar Footer */}
        <div className="p-4 border-t border-gray-150 space-y-4">
          <div className="flex items-center gap-3 px-2">
            {profile.profile_image ? (
              <img 
                src={`http://localhost:5000${profile.profile_image}`} 
                alt="Teacher" 
                className="w-10 h-10 rounded-full object-cover border border-tomato-500 shadow-sm"
                onError={(e) => { e.target.src = 'https://api.dicebear.com/7.x/initials/svg?seed=' + profile.name; }}
              />
            ) : (
              <div className="w-10 h-10 rounded-full bg-tomato-100 text-tomato-500 flex items-center justify-center border border-tomato-200 font-extrabold">
                {profile.name ? profile.name.charAt(0).toUpperCase() : 'T'}
              </div>
            )}
            <div className="min-w-0">
              <span className="font-bold text-xs text-dark-900 block truncate">{profile.name || 'Instructor'}</span>
              <span className="text-[10px] text-gray-400 font-semibold block truncate">{profile.email}</span>
            </div>
          </div>
          <button
            onClick={() => {
              localStorage.clear();
              navigate('/');
            }}
            className="w-full flex items-center justify-center gap-2 px-4 py-2.5 border border-gray-200 hover:border-tomato-500 hover:bg-tomato-50/10 hover:text-tomato-600 rounded-xl text-xs font-bold text-gray-650 transition-all active:scale-95"
          >
            <LogOut size={14} />
            <span>Sign Out</span>
          </button>
        </div>
      </div>

      {/* Mobile Sidebar Backdrop Overlay */}
      {isSidebarOpen && (
        <div 
          onClick={() => setIsSidebarOpen(false)}
          className="fixed inset-0 bg-black/40 backdrop-blur-sm z-30 lg:hidden"
        />
      )}

      {/* Main Content Area */}
      <div className="flex-grow flex-1 min-w-0 p-6 md:p-10 max-h-screen overflow-y-auto">
        
        {/* Header Summary */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
          <div>
            <h1 className="text-3xl font-bold text-dark-900">Teacher Console</h1>
            <p className="text-gray-400 text-sm">Schedule tests, write questions, and monitor real-time integrity logs.</p>
          </div>
          <button onClick={fetchData} className="tomato-btn-outline py-2 text-xs flex items-center gap-1.5">
            <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
            <span>Reload data</span>
          </button>
        </div>

        {/* Global Notifications */}
        {success && (
          <div className="bg-green-50 border border-green-200 text-green-700 py-3 px-5 rounded-xl text-xs font-semibold mb-6 flex items-center gap-2 animate-fade-in shadow-sm">
            <Check size={16} />
            <span>{success}</span>
          </div>
        )}

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 py-3 px-5 rounded-xl text-xs font-semibold mb-6 flex items-center gap-2 animate-fade-in shadow-sm">
            <AlertCircle size={16} />
            <span>{error}</span>
          </div>
        )}

        {/* Dynamic Panel */}
        <div className="bg-white rounded-2xl border border-gray-150 p-6 md:p-8 shadow-sm">
          
          {/* TAB: PROCTOR LOGS */}
          {activeTab === 'logs' && (
            <div className="space-y-8 animate-fade-in">
              <div className="flex justify-between items-center flex-wrap gap-4">
                <div>
                  <h3 className="text-lg font-bold text-dark-900 flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-tomato-500 animate-pulse"></span>
                    <span>Live Proctoring Activity Stream</span>
                  </h3>
                  <p className="text-xs text-gray-400">Updates automatically in real time. Aggregates browser copy-pasting and webcam YOLOv8 alerts.</p>
                </div>
                <div className="flex gap-2">
                  <button onClick={downloadLogs} className="tomato-btn py-1.5 px-3 text-xs flex items-center gap-1.5">
                    <Download size={14} />
                    <span>Download log file</span>
                  </button>
                  <button onClick={handleClearLogs} className="tomato-btn-outline border-gray-200 text-gray-600 hover:bg-gray-100 hover:text-dark-900 py-1.5 px-3 text-xs flex items-center gap-1.5">
                    <Trash size={14} />
                    <span>Clear log file</span>
                  </button>
                </div>
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Live alerts feed */}
                <div className="lg:col-span-2 space-y-4">
                  <h4 className="font-bold text-xs text-gray-400 uppercase tracking-widest">Active Incident Alerts</h4>
                  {proctoringLogs.length === 0 ? (
                    <div className="border border-dashed border-gray-200 rounded-xl p-8 text-center text-xs text-gray-400 bg-gray-50/20">
                      No cheating activities recorded yet. Safe testing environment.
                    </div>
                  ) : (
                    <div className="space-y-3 max-h-[500px] overflow-y-auto pr-2">
                      {proctoringLogs.map(log => (
                        <div key={log.id} className="border border-red-100 bg-red-50/20 p-4 rounded-xl flex items-start gap-3 smooth-transition hover:border-red-300">
                          <div className="w-8 h-8 rounded-full bg-red-50 text-red-500 flex items-center justify-center shrink-0">
                            <AlertCircle size={18} />
                          </div>
                          <div className="flex-1 min-w-0">
                            <div className="flex justify-between items-start flex-wrap gap-1 mb-1">
                              <p className="font-bold text-xs text-dark-900">
                                {log.student_name} <span className="font-mono text-gray-400">({log.student_id})</span>
                              </p>
                              <span className="text-[10px] text-gray-400 font-semibold">{new Date(log.timestamp).toLocaleTimeString()}</span>
                            </div>
                            <p className="text-[11px] text-gray-500 mb-1">
                              Exam: <span className="font-semibold text-dark-900">{log.exam_title}</span> ({log.course_name})
                            </p>
                            <p className="text-xs font-semibold text-red-700 capitalize">
                              Cheating flagged: {log.activity_type}
                            </p>
                            {log.details && (
                              <p className="text-xs text-gray-600 mt-1 bg-white border border-red-50 p-2 rounded-lg italic">
                                "{log.details}"
                              </p>
                            )}
                          </div>
                          <div className="text-right shrink-0">
                            <span className="bg-red-100 text-red-700 px-2 py-0.5 rounded text-[10px] font-bold">
                              +{log.demerit_points} Pts
                            </span>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                {/* Raw log file previewer */}
                <div className="space-y-4">
                  <h4 className="font-bold text-xs text-gray-400 uppercase tracking-widest">`cheating_activity.log` Preview</h4>
                  <div className="bg-dark-900 text-gray-300 font-mono text-[10px] p-4 rounded-2xl h-[400px] overflow-auto leading-relaxed border border-dark-850 shadow-inner">
                    <pre className="whitespace-pre-wrap">{rawLogs || 'Logs are empty.'}</pre>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* TAB: EXAMS & QUESTION BANK */}
          {activeTab === 'exams' && (
            <div className="space-y-8 animate-fade-in">
              <div className="flex justify-between items-center flex-wrap gap-4">
                <h3 className="text-lg font-bold text-dark-900">Manage Course Exams</h3>
                <button 
                  onClick={() => setIsExamModalOpen(true)}
                  className="tomato-btn py-2 text-xs flex items-center gap-1"
                >
                  <Plus size={14} />
                  <span>Create Exam Schedule</span>
                </button>
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Exams List */}
                <div className="lg:col-span-1 space-y-3">
                  <h4 className="font-bold text-xs text-gray-400 uppercase tracking-widest mb-2">Select Active Exam</h4>
                  {exams.length === 0 ? (
                    <p className="text-xs text-gray-400 py-2">No exams scheduled. Click Create Exam.</p>
                  ) : (
                    exams.map(exam => (
                      <div 
                        key={exam.id}
                        onClick={() => fetchQuestions(exam.id)}
                        className={`p-4 rounded-xl border cursor-pointer smooth-transition flex flex-col justify-between ${
                          selectedExamId === exam.id
                            ? 'border-tomato-500 bg-tomato-50/10 shadow-sm'
                            : 'border-gray-150 hover:border-tomato-300 bg-white'
                        }`}
                      >
                        <div className="flex justify-between items-start gap-2 mb-2">
                          <span className="bg-gray-100 text-gray-600 px-2.5 py-0.5 rounded text-[10px] font-bold font-mono">
                            {exam.course_code}
                          </span>
                          <button 
                            onClick={(e) => { e.stopPropagation(); handleDeleteExam(exam.id); }}
                            className="text-gray-300 hover:text-red-500 smooth-transition p-0.5"
                          >
                            <Trash2 size={14} />
                          </button>
                        </div>
                        <h5 className="font-bold text-xs text-dark-900 mb-2">{exam.title}</h5>
                        <div className="space-y-1 text-[10px] text-gray-400">
                          <p className="flex items-center gap-1"><Calendar size={12} /> {new Date(exam.exam_date).toLocaleString()}</p>
                          <p className="flex items-center gap-1"><Clock size={12} /> {exam.duration_minutes} Mins Duration</p>
                          <p className="flex items-center gap-1"><FileQuestion size={12} /> {exam.questions_count} Questions Added</p>
                        </div>
                      </div>
                    ))
                  )}
                </div>

                {/* Question builder panel */}
                <div className="lg:col-span-2 border border-gray-150 rounded-2xl p-6 bg-gray-50/20">
                  {selectedExamId ? (
                    <div className="space-y-6">
                      <div className="flex justify-between items-center flex-wrap gap-4">
                        <div>
                          <h4 className="font-bold text-sm text-dark-900">
                            Questions for: {exams.find(e => e.id === selectedExamId)?.title}
                          </h4>
                          <p className="text-xs text-gray-400">Add, view, and delete questions for the selected exam attempt.</p>
                        </div>
                        <button 
                          onClick={() => setIsQuestionModalOpen(true)}
                          className="tomato-btn py-1.5 px-3 text-xs flex items-center gap-1"
                        >
                          <Plus size={12} />
                          <span>Add Question</span>
                        </button>
                      </div>

                      {questions.length === 0 ? (
                        <div className="border border-dashed border-gray-200 bg-white py-12 rounded-xl text-center text-xs text-gray-400">
                          No questions loaded. Click Add Question.
                        </div>
                      ) : (
                        <div className="space-y-4 max-h-[400px] overflow-y-auto pr-2">
                          {questions.map((q, qidx) => (
                            <div key={q.id} className="border border-gray-150 bg-white p-4 rounded-xl relative">
                              <button 
                                onClick={() => handleDeleteQuestion(q.id)}
                                className="absolute top-4 right-4 text-gray-300 hover:text-red-500 smooth-transition"
                                title="Delete Question"
                              >
                                <Trash2 size={15} />
                              </button>
                              <p className="font-bold text-xs text-dark-900 mb-3 pr-6">
                                Q{qidx + 1}: {q.question_text}
                              </p>
                              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs mb-3">
                                <div className={`p-2 rounded-lg border ${q.correct_option === 'A' ? 'bg-green-50 border-green-200 text-green-700 font-semibold' : 'border-gray-100 text-gray-500'}`}>
                                  A) {q.option_a}
                                </div>
                                <div className={`p-2 rounded-lg border ${q.correct_option === 'B' ? 'bg-green-50 border-green-200 text-green-700 font-semibold' : 'border-gray-100 text-gray-500'}`}>
                                  B) {q.option_b}
                                </div>
                                <div className={`p-2 rounded-lg border ${q.correct_option === 'C' ? 'bg-green-50 border-green-200 text-green-700 font-semibold' : 'border-gray-100 text-gray-500'}`}>
                                  C) {q.option_c}
                                </div>
                                <div className={`p-2 rounded-lg border ${q.correct_option === 'D' ? 'bg-green-50 border-green-200 text-green-700 font-semibold' : 'border-gray-100 text-gray-500'}`}>
                                  D) {q.option_d}
                                </div>
                              </div>
                              <span className="text-[10px] text-green-600 bg-green-50 border border-green-100 px-2 py-0.5 rounded font-bold uppercase tracking-wider">
                                Correct: Option {q.correct_option}
                              </span>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  ) : (
                    <div className="py-24 text-center text-xs text-gray-400">
                      Select an exam from the left column to configure its question set.
                    </div>
                  )}
                </div>
              </div>
            </div>
          )}

          {/* TAB: ENROLLMENTS */}
          {activeTab === 'enrollments' && (
            <div className="space-y-8 animate-fade-in">
              <div className="flex justify-between items-center flex-wrap gap-4">
                <div>
                  <h3 className="text-lg font-bold text-dark-900">Manage Course Enrolees</h3>
                  <p className="text-xs text-gray-400">Directly enroll students or review course entry requests.</p>
                </div>
                <button 
                  onClick={() => setIsEnrollModalOpen(true)}
                  className="tomato-btn py-2 text-xs flex items-center gap-1"
                >
                  <Plus size={14} />
                  <span>Enroll Student</span>
                </button>
              </div>

              <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                {/* Pending requests */}
                <div>
                  <h4 className="font-bold text-xs text-gray-400 uppercase tracking-widest mb-3">Pending Student Requests</h4>
                  {pendingEnrollments.length === 0 ? (
                    <div className="border border-dashed border-gray-200 bg-gray-50/50 py-8 rounded-xl text-center text-xs text-gray-400">
                      No pending requests to approve.
                    </div>
                  ) : (
                    <div className="space-y-3">
                      {pendingEnrollments.map((req, idx) => (
                        <div key={idx} className="flex justify-between items-center border border-gray-150 p-4 rounded-xl bg-white text-xs">
                          <div>
                            <p className="font-bold text-dark-900">{req.student_name} ({req.student_id})</p>
                            <span className="text-gray-400">Course Request: <span className="font-semibold text-tomato-500">{req.course_code}</span></span>
                          </div>
                          <button 
                            onClick={() => handleApproveEnrollment(req.course_id, req.student_id)}
                            className="tomato-btn py-1 px-3 text-[11px] rounded-lg"
                          >
                            <Check size={12} />
                            <span>Accept</span>
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                {/* Course listing */}
                <div>
                  <h4 className="font-bold text-xs text-gray-400 uppercase tracking-widest mb-3">My Taught Courses</h4>
                  {courses.length === 0 ? (
                    <p className="text-xs text-gray-400 py-2">You are not assigned to teach any courses.</p>
                  ) : (
                    <div className="space-y-3">
                      {courses.map(course => (
                        <div key={course.id} className="border border-gray-150 p-4 rounded-xl flex justify-between items-center bg-white text-xs">
                          <div>
                            <span className="bg-gray-100 text-gray-600 px-2 py-0.5 rounded font-mono font-bold text-[10px]">{course.code}</span>
                            <h5 className="font-bold text-dark-900 mt-1">{course.name}</h5>
                          </div>
                          <span className="font-bold text-tomato-500 bg-tomato-50/50 border border-tomato-100/50 py-1 px-3 rounded-lg">
                            {course.enrolled_students_count} Active Enrolled
                          </span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            </div>
          )}

          {/* TAB: PROFILE SETTINGS */}
          {activeTab === 'profile' && (
            <div className="max-w-md animate-fade-in space-y-6">
              <h3 className="text-lg font-bold text-dark-900">Manage Instructor Profile</h3>
              
              <div className="flex items-center gap-4 bg-gray-50 p-4 rounded-2xl border border-gray-150">
                {profile.profile_image ? (
                  <img 
                    src={`http://localhost:5000${profile.profile_image}`} 
                    alt="Instructor" 
                    className="w-16 h-16 rounded-full object-cover border-2 border-tomato-500 shadow-md"
                    onError={(e) => { e.target.src = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=120&h=120&fit=crop'; }}
                  />
                ) : (
                  <div className="w-16 h-16 rounded-full bg-tomato-100 flex items-center justify-center text-tomato-600 border border-tomato-200 text-2xl font-bold">
                    {profile.name?.charAt(0)}
                  </div>
                )}
                <div>
                  <h4 className="font-bold text-dark-900">{profile.name}</h4>
                  <p className="text-xs text-gray-400 flex items-center gap-1 mt-0.5">
                    <Award size={13} />
                    <span>Joining Date: {new Date(profile.joining_date).toLocaleDateString()}</span>
                  </p>
                </div>
              </div>

              <form onSubmit={handleProfileSubmit} className="space-y-4 pt-2">
                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Display Name</label>
                  <input
                    type="text"
                    required
                    value={profileName}
                    onChange={(e) => setProfileName(e.target.value)}
                    className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:bg-white focus:border-tomato-500 focus:ring-1 focus:ring-tomato-500 smooth-transition"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Profile Picture Image</label>
                  <input
                    type="file"
                    accept="image/*"
                    onChange={(e) => setProfileImageFile(e.target.files[0])}
                    className="w-full text-xs text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-semibold file:bg-tomato-50 file:text-tomato-700 hover:file:bg-tomato-100 smooth-transition"
                  />
                </div>

                <button type="submit" className="tomato-btn py-3 w-full mt-4">
                  Save Changes
                </button>
              </form>
            </div>
          )}
        </div>
      </div>

      {/* POPUP MODALS */}

      {/* Modal: Schedule Exam */}
      <Modal isOpen={isExamModalOpen} onClose={() => setIsExamModalOpen(false)} title="Schedule Online Exam">
        <form onSubmit={handleCreateExam} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Select Course</label>
            <select
              required
              value={examForm.course_id}
              onChange={e => setExamForm({ ...examForm, course_id: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            >
              <option value="">-- Select Course --</option>
              {courses.map(course => (
                <option key={course.id} value={course.id}>{course.code} - {course.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Exam Title</label>
            <input 
              type="text" required placeholder="e.g. Midterm Assessment"
              value={examForm.title} 
              onChange={e => setExamForm({ ...examForm, title: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Date & Start Time</label>
            <input 
              type="datetime-local" required
              value={examForm.exam_date} 
              onChange={e => setExamForm({ ...examForm, exam_date: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Duration (Minutes)</label>
            <input 
              type="number" required placeholder="e.g. 45" min="1"
              value={examForm.duration_minutes} 
              onChange={e => setExamForm({ ...examForm, duration_minutes: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Publish Exam</button>
        </form>
      </Modal>

      {/* Modal: Add Question */}
      <Modal isOpen={isQuestionModalOpen} onClose={() => setIsQuestionModalOpen(false)} title="Add Multiple Choice Question">
        <form onSubmit={handleAddQuestion} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase font-mono">Question Text</label>
            <textarea 
              required placeholder="Type the question content here..."
              value={questionForm.question_text} 
              onChange={e => setQuestionForm({ ...questionForm, question_text: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 h-20 resize-none smooth-transition"
            />
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-gray-700 mb-1 uppercase">Option A</label>
              <input 
                type="text" required placeholder="First option"
                value={questionForm.option_a} 
                onChange={e => setQuestionForm({ ...questionForm, option_a: e.target.value })}
                className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-xs focus:outline-none focus:border-tomato-500 smooth-transition"
              />
            </div>
            <div>
              <label className="block text-xs font-bold text-gray-700 mb-1 uppercase">Option B</label>
              <input 
                type="text" required placeholder="Second option"
                value={questionForm.option_b} 
                onChange={e => setQuestionForm({ ...questionForm, option_b: e.target.value })}
                className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-xs focus:outline-none focus:border-tomato-500 smooth-transition"
              />
            </div>
            <div>
              <label className="block text-xs font-bold text-gray-700 mb-1 uppercase">Option C</label>
              <input 
                type="text" required placeholder="Third option"
                value={questionForm.option_c} 
                onChange={e => setQuestionForm({ ...questionForm, option_c: e.target.value })}
                className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-xs focus:outline-none focus:border-tomato-500 smooth-transition"
              />
            </div>
            <div>
              <label className="block text-xs font-bold text-gray-700 mb-1 uppercase">Option D</label>
              <input 
                type="text" required placeholder="Fourth option"
                value={questionForm.option_d} 
                onChange={e => setQuestionForm({ ...questionForm, option_d: e.target.value })}
                className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-xs focus:outline-none focus:border-tomato-500 smooth-transition"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Correct Option</label>
            <select
              required
              value={questionForm.correct_option}
              onChange={e => setQuestionForm({ ...questionForm, correct_option: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            >
              <option value="A">Option A</option>
              <option value="B">Option B</option>
              <option value="C">Option C</option>
              <option value="D">Option D</option>
            </select>
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Add to Question Pool</button>
        </form>
      </Modal>

      {/* Modal: Enroll Student */}
      <Modal isOpen={isEnrollModalOpen} onClose={() => setIsEnrollModalOpen(false)} title="Enroll Student in Course">
        <form onSubmit={handleDirectEnroll} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Select Course</label>
            <select
              required
              value={enrollForm.courseId}
              onChange={e => setEnrollForm({ ...enrollForm, courseId: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            >
              <option value="">-- Select Course --</option>
              {courses.map(course => (
                <option key={course.id} value={course.id}>{course.code} - {course.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Student ID</label>
            <input 
              type="text" required placeholder="e.g. STU1001"
              value={enrollForm.studentId} 
              onChange={e => setEnrollForm({ ...enrollForm, studentId: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Enroll Student</button>
        </form>
      </Modal>

    </div>
  );
}
