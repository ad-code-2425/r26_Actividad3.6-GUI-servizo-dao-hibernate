package com.example.hibernate.model.dao;

import org.hibernate.SessionFactory;

import com.example.hibernate.model.Profesor;
import com.example.hibernate.model.util.GenericDaoHibernate;


public class ProfesorDaoHibernate extends GenericDaoHibernate<Profesor, Integer> implements IProfesorDao {

	public ProfesorDaoHibernate(SessionFactory sessionFactory) {
		super(sessionFactory);
	}

	
}
