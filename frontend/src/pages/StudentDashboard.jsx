import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { 
  Calendar, BookOpen, KeyRound, CheckCircle2, ShieldAlert, 
  Hourglass, Play, RefreshCw, GraduationCap
} from 'lucide-react';
import Navbar from '../components/Navbar';

export default function StudentDashboard() {
  const navigate = useNavigate();
  const token = localStorage.getItem('token');
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  const [activeTab, setActiveTab] = useState('exams');

  // Data State
  const [exams, setExams] = useState([]);
  const [courses, setCourses] = useState([]);
  const [profile, setProfile] = useState({});

  // Password Update State
  const [pwData, setPwData] = useState({ oldPassword: '', newPassword: '' });

  // UI State
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const api = axios.create({
    headers: { Authorization: `Bearer ${token}` }
  });

  useEffect(() => {
    if (!token) {
      navigate('/login/student');
      return;
    }
    fetchData();
  }, [token]);

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const [exRes, cRes, pRes] = await Promise.all([
        api.get('http://localhost:5000/api/student/exams'),
        api.get('http://localhost:5000/api/student/courses/available'),
        api.get('http://localhost:5000/api/student/profile')
      ]);
      setExams(exRes.data);
      setCourses(cRes.data);
      setProfile(pRes.data);
    } catch (err) {
      console.error(err);
      if (err.response?.status === 401 || err.response?.status === 403) {
        localStorage.clear();
        navigate('/login/student');
      } else {
        setError('Failed to load portal data.');
      }
    } finally {
      setLoading(false);
    }
  };

  const triggerSuccess = (msg) => {
    setSuccess(msg);
    setTimeout(() => setSuccess(''), 4000);
  };

  const handlePasswordSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    try {
      await api.put('http://localhost:5000/api/student/change-password', pwData);
      triggerSuccess('Password updated successfully');
      setPwData({ oldPassword: '', newPassword: '' });
    } catch (err) {
      setError(err.response?.data?.message || 'Error updating password.');
    }
  };

  const handleRequestEnrollment = async (courseId) => {
    setError('');
    try {
      await api.post('http://localhost:5000/api/student/courses/request-enrollment', { courseId });
      triggerSuccess('Course enrollment request sent to instructor');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error requesting enrollment');
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <Navbar />

      <div className="flex-grow max-w-6xl w-full mx-auto px-6 py-10">
        
        {/* Header Summary */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
          <div>
            <h1 className="text-3xl font-bold text-dark-900">Student Portal</h1>
            <p className="text-gray-400 text-sm">Welcome back, {profile.name}! Track exams and course enrollment statuses.</p>
          </div>
          <button onClick={fetchData} className="tomato-btn-outline py-2 text-xs flex items-center gap-1">
            <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
            <span>Refresh Portal</span>
          </button>
        </div>

        {/* Status Alerts */}
        {success && (
          <div className="bg-green-50 border border-green-200 text-green-700 py-3 px-5 rounded-xl text-xs font-semibold mb-6 flex items-center gap-2 animate-fade-in shadow-sm">
            <CheckCircle2 size={16} />
            <span>{success}</span>
          </div>
        )}

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 py-3 px-5 rounded-xl text-xs font-semibold mb-6 flex items-center gap-2 animate-fade-in shadow-sm">
            <ShieldAlert size={16} />
            <span>{error}</span>
          </div>
        )}

        {/* Tab Navigation */}
        <div className="flex border-b border-gray-200 gap-2 mb-8 overflow-x-auto pb-1">
          {[
            { id: 'exams', label: 'My Online Exams', icon: Calendar },
            { id: 'courses', label: 'Course Catalog & Enrollment', icon: BookOpen },
            { id: 'profile', label: 'Profile & Password', icon: KeyRound }
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => { setActiveTab(tab.id); setError(''); }}
              className={`flex items-center gap-2 px-5 py-3 font-semibold text-sm rounded-t-xl transition-all ${
                activeTab === tab.id 
                  ? 'border-b-2 border-tomato-500 text-tomato-600 bg-white shadow-sm'
                  : 'text-gray-500 hover:text-dark-900 hover:bg-gray-150/50'
              }`}
            >
              <tab.icon size={16} />
              <span>{tab.label}</span>
            </button>
          ))}
        </div>

        {/* Dynamic Panel */}
        <div className="bg-white rounded-2xl border border-gray-150 p-6 md:p-8 shadow-sm">
          
          {/* TAB: EXAMS */}
          {activeTab === 'exams' && (
            <div className="space-y-6 animate-fade-in">
              <h3 className="text-lg font-bold text-dark-900">Available Exam Sittings</h3>
              
              {exams.length === 0 ? (
                <div className="border border-dashed border-gray-200 bg-gray-50/20 py-12 text-center text-xs text-gray-400 rounded-xl">
                  You are not currently scheduled for any exams. Enroll in courses to access testing.
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {exams.map(exam => {
                    const isUpcoming = new Date(exam.exam_date) > new Date();
                    const isFinished = exam.exam_status === 'completed';
                    const isBlocked = exam.block_until && new Date(exam.block_until) > new Date();

                    return (
                      <div key={exam.id} className="border border-gray-150 p-5 rounded-2xl flex flex-col justify-between bg-white relative hover:shadow-md smooth-transition">
                        <div>
                          <div className="flex justify-between items-start mb-3">
                            <span className="bg-tomato-50 text-tomato-600 border border-tomato-100 px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider font-mono">
                              {exam.course_code}
                            </span>
                            
                            {isFinished ? (
                              <span className="bg-green-50 text-green-700 border border-green-250 px-2.5 py-0.5 rounded text-[10px] font-bold">
                                Score: {exam.score}
                              </span>
                            ) : isBlocked ? (
                              <span className="bg-red-50 text-red-700 border border-red-200 px-2 py-0.5 rounded text-[10px] font-bold flex items-center gap-1 animate-pulse">
                                <ShieldAlert size={12} />
                                <span>Locked</span>
                              </span>
                            ) : (
                              <span className="bg-yellow-50 text-yellow-700 border border-yellow-200 px-2 py-0.5 rounded text-[10px] font-bold">
                                Scheduled
                              </span>
                            )}
                          </div>

                          <h4 className="font-bold text-dark-900 text-sm mb-1">{exam.title}</h4>
                          <p className="text-[11px] text-gray-400 mb-4">{exam.course_name}</p>

                          <div className="space-y-1.5 text-[11px] text-gray-500 border-t border-gray-100 pt-3">
                            <p className="flex items-center gap-1.5"><Calendar size={13} /> {new Date(exam.exam_date).toLocaleString()}</p>
                            <p className="flex items-center gap-1.5"><Hourglass size={13} /> {exam.duration_minutes} Mins Limit</p>
                          </div>
                        </div>

                        <div className="mt-5 pt-2">
                          {isFinished ? (
                            <div className="bg-green-50/35 border border-green-100 rounded-xl p-3 text-center text-xs font-semibold text-green-800">
                              Exam Completed Successfully
                            </div>
                          ) : (
                            <button
                              onClick={() => navigate(`/exam/${exam.id}`)}
                              className="tomato-btn w-full py-2.5 text-xs flex items-center justify-center gap-1"
                            >
                              <Play size={12} fill="white" />
                              <span>{exam.exam_status === 'started' ? 'Resume Exam' : 'Enter Exam'}</span>
                            </button>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>
          )}

          {/* TAB: COURSE CATALOG */}
          {activeTab === 'courses' && (
            <div className="space-y-8 animate-fade-in">
              {/* My active enrolled courses */}
              <div>
                <h3 className="text-lg font-bold text-dark-900 mb-4 flex items-center gap-2">
                  <GraduationCap size={18} className="text-tomato-500" />
                  <span>My Enrolled Courses</span>
                </h3>
                {courses.filter(c => c.enrollment_status === 'approved').length === 0 ? (
                  <p className="text-xs text-gray-400 py-1">You are not enrolled in any courses yet.</p>
                ) : (
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {courses.filter(c => c.enrollment_status === 'approved').map(course => (
                      <div key={course.id} className="border border-gray-150 p-4 rounded-xl flex justify-between items-center bg-gray-55/30 text-xs">
                        <div>
                          <span className="bg-gray-100 text-gray-650 px-2 py-0.5 rounded font-mono font-bold text-[9px]">{course.code}</span>
                          <h5 className="font-bold text-dark-900 mt-1">{course.name}</h5>
                        </div>
                        <span className="text-[10px] bg-green-50 border border-green-150 text-green-700 py-1 px-3 rounded-lg font-bold">
                          Enrolled
                        </span>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              {/* Available catalog */}
              <div>
                <h3 className="text-lg font-bold text-dark-900 mb-4">Course Registration Catalog</h3>
                <div className="overflow-x-auto border border-gray-150 rounded-xl">
                  <table className="w-full text-left text-xs border-collapse">
                    <thead>
                      <tr className="bg-gray-50 border-b border-gray-150 text-gray-500 font-bold uppercase tracking-wider">
                        <th className="p-4">Course Code</th>
                        <th className="p-4">Course Name</th>
                        <th className="p-4">Instructor</th>
                        <th className="p-4 text-center">Status / Action</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-150">
                      {courses.map(course => (
                        <tr key={course.id} className="hover:bg-gray-50/50">
                          <td className="p-4 font-mono font-bold text-dark-900">{course.code}</td>
                          <td className="p-4 font-semibold text-dark-900">{course.name}</td>
                          <td className="p-4 text-gray-500">{course.teacher_name || 'Unassigned'}</td>
                          <td className="p-4 text-center flex justify-center">
                            {course.enrollment_status === 'approved' ? (
                              <span className="text-green-600 font-bold">Active Enrolled</span>
                            ) : course.enrollment_status === 'pending' ? (
                              <span className="text-yellow-600 bg-yellow-50 border border-yellow-100 px-3 py-1 rounded-lg font-bold text-[10px]">
                                Pending Approval
                              </span>
                            ) : (
                              <button 
                                onClick={() => handleRequestEnrollment(course.id)}
                                className="tomato-btn py-1.5 px-4 text-[10px]"
                              >
                                Request Enrollment
                              </button>
                            )}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}

          {/* TAB: PROFILE & PASSWORD */}
          {activeTab === 'profile' && (
            <div className="max-w-md animate-fade-in space-y-6">
              <h3 className="text-lg font-bold text-dark-900">Student Profile Credentials</h3>
              
              <div className="bg-gray-50 p-5 rounded-2xl border border-gray-150 space-y-3 text-xs">
                <div>
                  <span className="text-gray-400 block text-[10px] uppercase font-semibold">Student ID</span>
                  <span className="font-mono font-bold text-dark-900 text-sm">{profile.id}</span>
                </div>
                <div>
                  <span className="text-gray-400 block text-[10px] uppercase font-semibold">Full Name</span>
                  <span className="font-bold text-dark-900">{profile.name}</span>
                </div>
                <div>
                  <span className="text-gray-400 block text-[10px] uppercase font-semibold">Email Address</span>
                  <span className="font-semibold text-gray-600">{profile.email}</span>
                </div>
              </div>

              <div className="border-t border-gray-150 pt-6">
                <h4 className="font-bold text-sm text-dark-900 mb-4 flex items-center gap-1.5">
                  <KeyRound size={16} className="text-tomato-500" />
                  <span>Update Password</span>
                </h4>
                
                <form onSubmit={handlePasswordSubmit} className="space-y-4">
                  <div>
                    <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Current Password</label>
                    <input 
                      type="password" required placeholder="••••••••"
                      value={pwData.oldPassword}
                      onChange={e => setPwData({ ...pwData, oldPassword: e.target.value })}
                      className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">New Password</label>
                    <input 
                      type="password" required placeholder="••••••••"
                      value={pwData.newPassword}
                      onChange={e => setPwData({ ...pwData, newPassword: e.target.value })}
                      className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
                    />
                  </div>
                  <button type="submit" className="tomato-btn w-full py-2.5 mt-2">
                    Submit Password Change
                  </button>
                </form>
              </div>
            </div>
          )}

        </div>
      </div>
    </div>
  );
}
