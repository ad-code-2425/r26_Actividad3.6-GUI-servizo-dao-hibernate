package com.example.hibernate;

import java.awt.Color;
import java.awt.Component;
import java.awt.Dialog;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.ListSelectionModel;
import javax.swing.SwingUtilities;
import javax.swing.border.EmptyBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import org.hibernate.SessionFactory;

import com.example.hibernate.model.Profesor;
import com.example.hibernate.model.dao.ProfesorDaoHibernate;
import com.example.hibernate.model.servicio.IProfesorServicio;
import com.example.hibernate.model.servicio.ProfesorServicio;
import com.example.hibernate.model.util.TransactionManager;
import com.example.hibernate.model.util.exceptions.InstanceNotFoundException;
import com.example.hibernate.util.HibernateUtil;



public class ProfesorWindow extends JFrame {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private JPanel contentPane;

	private JTextArea mensajes_text_Area;
	private JList<Profesor> JLIstAllProfesors;

	private IProfesorServicio profesorServicio;
	private TransactionManager transactionManager;
	private SessionFactory sessionFactory;
	
	private CreateNewProfeDialog createDialog;
	private JButton btnModificarProfe;
	private JButton btnEliminarProfe;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					ProfesorWindow frame = new ProfesorWindow();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public ProfesorWindow() {
		this.sessionFactory = HibernateUtil.getInstance().getSessionFactory();
		this.transactionManager = new TransactionManager(sessionFactory);

		profesorServicio = new ProfesorServicio(transactionManager, new ProfesorDaoHibernate(sessionFactory));

		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 847, 772);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		JPanel panel = new JPanel();
		panel.setBounds(8, 8, 821, 500);
		contentPane.add(panel);
		panel.setLayout(null);

		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(19, 264, 669, 228);
		panel.add(scrollPane);

		mensajes_text_Area = new JTextArea();
		scrollPane.setViewportView(mensajes_text_Area);
		mensajes_text_Area.setEditable(false);
		mensajes_text_Area.setText("Panel de mensajes");
		mensajes_text_Area.setForeground(new Color(255, 0, 0));
		mensajes_text_Area.setFont(new Font("Monospaced", Font.PLAIN, 13));

		JButton btnShowAllDepts = new JButton("Mostrar profesores");

		btnShowAllDepts.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnShowAllDepts.setBounds(50, 37, 208, 36);
		panel.add(btnShowAllDepts);

		btnModificarProfe = new JButton("Modificar profesor");

		JLIstAllProfesors = new JList<Profesor>();

		JLIstAllProfesors.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

		JLIstAllProfesors.setBounds(403, 37, 377, 200);

		JScrollPane scrollPanel_in_JLIstAllProfesors = new JScrollPane(JLIstAllProfesors);

		scrollPanel_in_JLIstAllProfesors.setLocation(300, 0);
		scrollPanel_in_JLIstAllProfesors.setSize(500, 250);

		panel.add(scrollPanel_in_JLIstAllProfesors);

		JButton btnCrearNuevoProfesor = new JButton("Crear nuevo profesor");

		btnCrearNuevoProfesor.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnCrearNuevoProfesor.setBounds(50, 85, 208, 36);
		panel.add(btnCrearNuevoProfesor);

		btnModificarProfe.setEnabled(false);
		btnModificarProfe.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnModificarProfe.setBounds(50, 139, 208, 36);
		panel.add(btnModificarProfe);

		btnEliminarProfe = new JButton("Eliminar profesor");

		btnEliminarProfe.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnEliminarProfe.setEnabled(false);
		btnEliminarProfe.setBounds(50, 201, 208, 36);
		panel.add(btnEliminarProfe);

		// Eventos
		ActionListener showAllProfesActionListener = new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				getAllProfes();
			}
		};
		btnShowAllDepts.addActionListener(showAllProfesActionListener);

		ActionListener crearListener = new ActionListener() {

			public void actionPerformed(ActionEvent e) {

				JFrame owner = (JFrame) SwingUtilities.getRoot((Component) e.getSource());
				createDialog = new CreateNewProfeDialog(owner, "Crear nuevo profesor",
						Dialog.ModalityType.DOCUMENT_MODAL, null);
				showDialog();
			}
		};
		btnCrearNuevoProfesor.addActionListener(crearListener);

		ActionListener modificarListener = new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int selectedIx = JLIstAllProfesors.getSelectedIndex();
				if (selectedIx > -1) {
					Profesor profesor = (Profesor) JLIstAllProfesors.getModel().getElementAt(selectedIx);
					if (profesor != null) {

						JFrame owner = (JFrame) SwingUtilities.getRoot((Component) e.getSource());

						createDialog = new CreateNewProfeDialog(owner, "Modificar profesor",
								Dialog.ModalityType.DOCUMENT_MODAL, profesor);
						showDialog();
					}
				}
			}
		};

		btnModificarProfe.addActionListener(modificarListener);

		ListSelectionListener selectionListListener = new ListSelectionListener() {
			public void valueChanged(ListSelectionEvent e) {
				if (e.getValueIsAdjusting() == false) {
					int selectedIx = JLIstAllProfesors.getSelectedIndex();
					btnModificarProfe.setEnabled((selectedIx > -1));
					btnEliminarProfe.setEnabled((selectedIx > -1));
					if (selectedIx > -1) {
						Profesor d = (Profesor) ProfesorWindow.this.JLIstAllProfesors.getModel()
								.getElementAt(selectedIx);
						if (d != null) {
							addMensaje(true, "Se ha seleccionado el profe: " + d);
						}
					}
				}
			}
		};
		JLIstAllProfesors.addListSelectionListener(selectionListListener);

		ActionListener deleteListener = new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int selectedIx = JLIstAllProfesors.getSelectedIndex();
				if (selectedIx > -1) {
					Profesor profe = (Profesor) JLIstAllProfesors.getModel().getElementAt(selectedIx);
					if (profe != null) {
						try {
							profesorServicio.delete(profe.getId());

							getAllProfes();
							addMensaje(true, "Se ha eliminado con éxito el profesor  con id: "
									+ profe.getId());
						} catch (InstanceNotFoundException e1) {
							addMensaje(true, "No se ha podido borrar el profesor. No se ha encontrado con id: "
									+ profe.getId());
						} catch (Exception ex) {
							addMensaje(true, "No se ha podido borrar el profesor. ");
							System.out.println("Exception: " + ex.getMessage());
							ex.printStackTrace();
						}
					}
				}
			}
		};
		btnEliminarProfe.addActionListener(deleteListener);
	}

	private void addMensaje(boolean keepText, String msg) {
		String oldText = "";
		if (keepText) {
			oldText = mensajes_text_Area.getText();

		}
		oldText = oldText + "\n" + msg;
		mensajes_text_Area.setText(oldText);

	}

	private void showDialog() {
		createDialog.setVisible(true);
		Profesor profesorACrearOModificar = createDialog.getResult();
		if (profesorACrearOModificar != null) {

			if (profesorACrearOModificar.getId() == null) {
				try {
					profesorServicio.crear(profesorACrearOModificar);
					addMensaje(true,
							"El profesor se ha creado correctamente con id: " + profesorACrearOModificar.getId());
					getAllProfes();
				} catch (Exception ex) {
					ex.printStackTrace();
					addMensaje(true, "El profesor no se ha podido crear  " + ex.getMessage());
				}
			} else {
				// Tiene id, se está actualizando...

				try {
					profesorServicio.actualizar(profesorACrearOModificar);
					addMensaje(true,
							"El profesor se ha actualizado correctamente con id: " + profesorACrearOModificar.getId());
					getAllProfes();
				} catch (Exception ex) {
					ex.printStackTrace();
					addMensaje(true,
							"El profesor con id: " + profesorACrearOModificar.getId() + " no se ha podido actualizar  "
									+ ex.getMessage());
				}
			}
		}

	}



	private void getAllProfes() {
		List<Profesor> profes = profesorServicio.findAll();

		DefaultListModel<Profesor> defModel = new DefaultListModel<>();

		defModel.addAll(profes);

		JLIstAllProfesors.setModel(defModel);

	}

}